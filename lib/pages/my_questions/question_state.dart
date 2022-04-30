import 'package:flutter/material.dart';
import 'package:interviewer/models/answers/value_answer.dart';
import 'package:interviewer/models/question.dart';

class QuestionState with ChangeNotifier {
  final Question question;

  QuestionState({required this.question});

  void setAnswerSelected(
      SelectValueAnswer answer, SelectValue value, bool isSelected) {
    if (answer.isMultipleSelect) {
      question.answer.values = question.answer.values
          .map((a) => a.id == value.id ? a.copyWith(isSelected: isSelected) : a)
          .toList();
    } else {
      question.answer.values = question.answer.values
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