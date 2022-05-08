import 'package:interviewer/models/answers/answer.dart';

class InputNumberAnswer extends Answer {
  String id;
  InputNumberType type;
  double value;

  InputNumberAnswer(
      {required this.id, required this.type, required this.value});
}

enum InputNumberType { integer, double }
