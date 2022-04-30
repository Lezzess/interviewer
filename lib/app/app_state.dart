import 'package:flutter/material.dart';
import 'package:interviewer/models/answers/value_answer.dart';
import 'package:interviewer/models/question.dart';
import 'package:uuid/uuid.dart';

class AppState with ChangeNotifier {
  final questions = <Question>[
    Question(
        id: const Uuid().v4(),
        text: 'First',
        answer: SelectValueAnswer(
            id: const Uuid().v4(),
            values: [
              SelectValue(
                  id: const Uuid().v4(), value: 'One', isSelected: false),
              SelectValue(
                  id: const Uuid().v4(), value: 'Two', isSelected: false),
              SelectValue(
                  id: const Uuid().v4(), value: 'Three', isSelected: false)
            ],
            isMultipleSelect: true)),
    Question(
        id: const Uuid().v4(),
        text: 'Second',
        answer: SelectValueAnswer(
            id: const Uuid().v4(),
            values: [
              SelectValue(
                  id: const Uuid().v4(), value: 'Four', isSelected: false)
            ],
            isMultipleSelect: true)),
    Question(
        id: const Uuid().v4(),
        text: 'Third',
        answer: SelectValueAnswer(
            id: const Uuid().v4(),
            values: [
              SelectValue(
                  id: const Uuid().v4(), value: 'Five', isSelected: false),
              SelectValue(
                  id: const Uuid().v4(), value: 'Six', isSelected: false),
              SelectValue(
                  id: const Uuid().v4(), value: 'Seven', isSelected: false)
            ],
            isMultipleSelect: false)),
  ];
}
