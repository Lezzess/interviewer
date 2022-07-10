import 'package:flutter/material.dart';
import 'package:interviewer/db/db.dart';
import 'package:interviewer/models/answers/input_number_answer.dart';
import 'package:interviewer/models/answers/input_text_answer.dart';
import 'package:interviewer/models/answers/select_value_answer.dart';
import 'package:interviewer/models/company.dart';
import 'package:interviewer/models/folder.dart';
import 'package:interviewer/models/question.dart';
import 'package:interviewer/states/companies_state.dart';
import 'package:interviewer/repositories/questions.dart' as rquestions;
import 'package:sqflite/sqflite.dart';

class QuestionsState with ChangeNotifier {
  List<Question> questions;

  QuestionsState(this.questions);

  void add(Question question) async {
    await Db.transaction((txn) async {
      questions.add(question);
      notifyListeners();
      await rquestions.add(txn, question);
    });
  }

  void update(Question oldQuestion, Question newQuestion) async {
    await Db.transaction((txn) async {
      final oldQuestionsIndex = questions.indexOf(oldQuestion);
      questions[oldQuestionsIndex] = newQuestion;
      notifyListeners();

      await rquestions.updateWithAnswers(txn, oldQuestion, newQuestion);
    });
  }

  void remove(Question question) async {
    await Db.transaction((txn) async {
      questions.remove(question);
      notifyListeners();
      await rquestions.remove(txn, question);
    });
  }

  void removeCompanyQuestions(Transaction txn, Company company) async {
    final questionsToRemove = <Question>[];
    final newQuestions = <Question>[];

    for (final question in questions) {
      if (question.companyId == company.id) {
        questionsToRemove.add(question);
        continue;
      }

      newQuestions.add(question);
    }

    questions = newQuestions;
    notifyListeners();

    for (final question in questionsToRemove) {
      await rquestions.remove(txn, question);
    }
  }

  void removeQuestionsFolder(Transaction txn, Folder folder) async {
    final questionsToUpdate = <Question>[];

    for (final question in questions) {
      if (question.folderId == folder.id) {
        question.folderId = null;
        questionsToUpdate.add(question);
      }
    }
    notifyListeners();

    for (final question in questionsToUpdate) {
      await rquestions.update(txn, question);
    }
  }

  void fillFromTemplate(String companyId, CompaniesState companiesState) async {
    await Db.transaction((txn) async {
      final templateCompany = companiesState.companies.firstWhere(
        (c) => c.isTemplate,
      );
      final templateQuestions = questions.where(
        (q) => q.companyId == templateCompany.id,
      );

      final copiedQuestions = templateQuestions
          .map((q) => q.clone(companyId: companyId, generateNewGuid: true))
          .toList();
      questions.addAll(copiedQuestions);

      notifyListeners();

      for (final question in copiedQuestions) {
        await rquestions.add(txn, question);
      }
    });
  }

  void saveNote(Question question, String text) async {
    await Db.transaction((txn) async {
      question.note = text;
      notifyListeners();
      await rquestions.update(txn, question);
    });
  }

  void selectAnswerValue(
    SelectValueAnswer answer,
    SelectValue selectedValue,
    bool isSelected,
  ) async {
    await Db.transaction((txn) async {
      for (final value in answer.values) {
        if (value == selectedValue) {
          value.isSelected = isSelected;
        }

        if (!answer.isMultiselect &&
            value != selectedValue &&
            value.isSelected) {
          value.isSelected = false;
        }
      }
      notifyListeners();

      await rquestions.updateAnswer(txn, answer);
    });
  }

  void setAnswerText(InputTextAnswer answer, String text) async {
    await Db.transaction((txn) async {
      answer.text = text;
      notifyListeners();
      await rquestions.updateAnswer(txn, answer);
    });
  }

  void setAnswerValue(InputNumberAnswer answer, double? value) async {
    await Db.transaction((txn) async {
      answer.value = value;
      notifyListeners();
      await rquestions.updateAnswer(txn, answer);
    });
  }
}
