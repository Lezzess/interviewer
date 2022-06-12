import 'package:interviewer/models/answers/answer.dart';
import 'package:uuid/uuid.dart';

class Question {
  String id;
  String text;
  Answer? answer;

  Question.empty()
      : id = const Uuid().v4(),
        text = '';

  Question({required this.id, required this.text, required this.answer});

  Question copyWith({String? id, String? text, Answer? answer}) {
    return Question(
        id: id ?? this.id,
        text: text ?? this.text,
        answer: answer ?? this.answer);
  }

  Question clone() {
    final newAnswer = answer?.clone();
    return copyWith(answer: newAnswer);
  }
}
