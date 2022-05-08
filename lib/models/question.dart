import 'package:interviewer/models/answers/answer.dart';

class Question {
  String id;
  String text;
  Answer answer;

  Question({required this.id, required this.text, required this.answer});
}
