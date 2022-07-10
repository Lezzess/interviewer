import 'package:flutter/material.dart';
import 'package:interviewer/models/answers/input_number_answer.dart';
import 'package:interviewer/models/answers/input_text_answer.dart';
import 'package:interviewer/models/answers/select_value_answer.dart';
import 'package:interviewer/models/company.dart';
import 'package:interviewer/models/folder.dart';
import 'package:interviewer/models/question.dart';
import 'package:interviewer/states/companies_state.dart';

class QuestionsState with ChangeNotifier {
  List<Question> questions;

  QuestionsState(this.questions);

  void add(Question question) {
    questions.add(question);
    notifyListeners();
  }

  void update(Question oldQuestion, Question newQuestion) {
    final oldQuestionsIndex = questions.indexOf(oldQuestion);
    questions[oldQuestionsIndex] = newQuestion;
    notifyListeners();
  }

  void remove(Question question) {
    questions.remove(question);
    notifyListeners();
  }

  void removeCompanyQuestions(Company company) {
    final newQuestions =
        questions.where((q) => q.companyId != company.id).toList();
    questions = newQuestions;
    notifyListeners();
  }

  void removeQuestionsFolder(Folder folder) {
    for (final question in questions) {
      if (question.folderId == folder.id) {
        question.folderId = null;
      }
    }
    notifyListeners();
  }

  void fillFromTemplate(String companyId, CompaniesState companiesState) {
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
  }

  void saveNote(Question question, String text) {
    question.note = text;
    notifyListeners();
  }

  void selectAnswerValue(
    SelectValueAnswer answer,
    SelectValue selectedValue,
    bool isSelected,
  ) {
    for (final value in answer.values) {
      if (value == selectedValue) {
        value.isSelected = isSelected;
      }

      if (!answer.isMultiselect && value != selectedValue && value.isSelected) {
        value.isSelected = false;
      }
    }
    notifyListeners();
  }

  void setAnswerText(InputTextAnswer answer, String text) {
    answer.text = text;
    notifyListeners();
  }

  void setAnswerValue(InputNumberAnswer answer, double? value) {
    answer.value = value;
    notifyListeners();
  }
}
