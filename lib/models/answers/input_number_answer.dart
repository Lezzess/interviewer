import 'package:interviewer/models/answers/answer.dart';
import 'package:interviewer/models/answers/answer_type.dart';
import 'package:uuid/uuid.dart';

class InputNumberAnswer extends Answer {
  double? value;

  InputNumberAnswer.empty(String questionId)
      : this(
          id: const Uuid().v4(),
          value: null,
          questionId: questionId,
        );

  InputNumberAnswer({
    required String id,
    required this.value,
    required String questionId,
  }) : super(id, AnswerType.inputNumber, questionId);

  Map<String, dynamic> toDb() {
    return {
      'id': id,
      'type': type.name,
      'value_double': value,
      'question_id': questionId,
    };
  }

  InputNumberAnswer.fromDb(Map<String, dynamic> entry)
      : this(
          id: entry['id'],
          value: entry['value_double'],
          questionId: entry['question_id'],
        );

  @override
  Answer clone({bool generateNewGuid = false}) {
    final id = generateNewGuid ? const Uuid().v4() : this.id;
    return InputNumberAnswer(
      id: id,
      value: value,
      questionId: questionId,
    );
  }
}
