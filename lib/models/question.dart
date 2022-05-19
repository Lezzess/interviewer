import 'package:interviewer/models/answers/answer.dart';

class Question {
  String id;
  String text;
  Answer answer;

  Question({required this.id, required this.text, required this.answer});

  Question copyWith({String? id, String? text, Answer? answer}) {
    return Question(
        id: id ?? this.id,
        text: text ?? this.text,
        answer: answer ?? this.answer);
  }
}
