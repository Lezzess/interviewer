import 'package:interviewer/models/answers/value_answer.dart';

class Question {
  String id;
  String text;
  SelectValueAnswer answer;

  Question({required this.id, required this.text, required this.answer});
}
