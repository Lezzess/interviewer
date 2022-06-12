import 'package:interviewer/models/answers/answer.dart';
import 'package:interviewer/models/answers/answer_type.dart';
import 'package:uuid/uuid.dart';

class InputTextAnswer extends Answer {
  String id;
  String text;

  InputTextAnswer.empty() : this(id: const Uuid().v4(), text: '');

  InputTextAnswer({required this.id, required this.text})
      : super(AnswerType.inputText);

  InputTextAnswer copyWith({String? id, String? text}) {
    return InputTextAnswer(id: id ?? this.id, text: text ?? this.text);
  }

  @override
  Answer clone() {
    return copyWith();
  }
}
