import 'package:interviewer/models/answers/answer.dart';

class InputTextAnswer extends Answer {
  String id;
  String text;

  InputTextAnswer({required this.id, required this.text});

  InputTextAnswer copyWith({String? id, String? text}) {
    return InputTextAnswer(id: id ?? this.id, text: text ?? this.text);
  }
}
