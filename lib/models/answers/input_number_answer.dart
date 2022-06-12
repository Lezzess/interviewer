import 'package:interviewer/models/answers/answer.dart';
import 'package:interviewer/models/answers/answer_type.dart';
import 'package:uuid/uuid.dart';

class InputNumberAnswer extends Answer {
  String id;
  double? value;

  InputNumberAnswer.empty() : this(id: const Uuid().v4(), value: null);

  InputNumberAnswer({required this.id, required this.value})
      : super(AnswerType.inputNumber);

  InputNumberAnswer copyWith({String? id, double? value}) {
    return InputNumberAnswer(id: id ?? this.id, value: value ?? this.value);
  }

  @override
  Answer clone() {
    return copyWith();
  }
}
