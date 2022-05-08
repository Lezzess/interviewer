import 'package:flutter/material.dart';
import 'package:interviewer/models/answers/select_value_answer.dart';
import 'package:interviewer/models/question.dart';

class QuestionState with ChangeNotifier {
  final Question question;

  QuestionState({required this.question});

  void setAnswerSelected(
      SelectValueAnswer answer, SelectValue value, bool isSelected) {
    final answer = question.answer as SelectValueAnswer;
    if (answer.isMultipleSelect) {
      answer.values = answer.values
          .map((a) => a.id == value.id ? a.copyWith(isSelected: isSelected) : a)
          .toList();
    } else {
      answer.values = answer.values
          .map((a) => a.id == value.id
              ? a.copyWith(isSelected: isSelected)
              : a.id != value.id && a.isSelected
                  ? a.copyWith(isSelected: false)
                  : a)
          .toList();
    }

    notifyListeners();
  }
}
