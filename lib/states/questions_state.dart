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
import 'package:collection/collection.dart';

class QuestionsState with ChangeNotifier {
  Map<String, List<Question>> questionsMap;

  QuestionsState(List<Question> questions)
      : questionsMap = questions.groupListsBy((q) => q.companyId);

  void add(Question question) async {
    await Db.transaction((txn) async {
      var questions = getQuestions(question.companyId);
      questions.add(question);

      notifyListeners();

      await rquestions.add(txn, question);
    });
  }

  void update(Question oldQuestion, Question newQuestion) async {
    await Db.transaction((txn) async {
      final questions = getQuestions(oldQuestion.companyId);
      final oldQuestionsIndex = questions.indexOf(oldQuestion);
      questions[oldQuestionsIndex] = newQuestion;

      notifyListeners();

      await rquestions.updateWithAnswers(txn, oldQuestion, newQuestion);
    });
  }

  void remove(Question question) async {
    await Db.transaction((txn) async {
      final questions = getQuestions(question.companyId);
      questions.remove(question);

      notifyListeners();

      await rquestions.remove(txn, question);
    });
  }

  void removeCompanyQuestions(Transaction txn, Company company) async {
    final questionsToRemove = getQuestions(company.id);
    questionsMap.remove(company.id);

    notifyListeners();

    for (final question in questionsToRemove) {
      await rquestions.remove(txn, question);
    }
  }

  void removeQuestionsFolder(Transaction txn, Folder folder) async {
    final questionsToUpdate = <Question>[];

    for (final questions in questionsMap.values) {
      for (final question in questions) {
        if (question.folderId == folder.id) {
          question.folderId = null;
          questionsToUpdate.add(question);
        }
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
      final templateQuestions = getQuestions(templateCompany.id);

      final copiedQuestions = templateQuestions
          .map((q) => q.clone(companyId: companyId, generateNewGuid: true))
          .toList();
      questionsMap[companyId] = copiedQuestions;

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

  List<Question> getQuestions(String companyId) {
    var questions = questionsMap[companyId];
    if (questions == null) {
      questions = [];
      questionsMap[companyId] = questions;
    }

    return questions;
  }
}
