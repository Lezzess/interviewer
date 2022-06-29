import 'package:uuid/uuid.dart';

class Question {
  String id;
  String text;
  String? answerId;

  Question.empty()
      : id = const Uuid().v4(),
        text = '',
        answerId = null;

  Question({required this.id, required this.text, required this.answerId});

  Question copyWith({String? id, String? text, String? answerId}) {
    return Question(
        id: id ?? this.id,
        text: text ?? this.text,
        answerId: answerId ?? this.answerId);
  }

  Question clone() {
    return copyWith();
  }
}
