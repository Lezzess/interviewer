import 'package:interviewer/models/answers/answer.dart';

class InputNumberAnswer extends Answer {
  String id;
  double? value;

  InputNumberAnswer({required this.id, required this.value});

  InputNumberAnswer copyWith({String? id, double? value}) {
    return InputNumberAnswer(id: id ?? this.id, value: value ?? this.value);
  }
}
