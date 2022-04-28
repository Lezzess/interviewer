import 'package:flutter/material.dart';
import 'package:interviewer/models/question.dart';

class AppState with ChangeNotifier {
  final questions = <Question>[
    Question(text: 'First'),
    Question(text: 'Second'),
    Question(text: 'Third')
  ];
}
