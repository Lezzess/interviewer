import 'package:interviewer/models/answers/answer.dart';
import 'package:interviewer/models/answers/answer_type.dart';
import 'package:uuid/uuid.dart';

class InputTextAnswer extends Answer {
  String text;
  bool isMultiline;

  InputTextAnswer.empty(String questionId)
      : this(
          id: const Uuid().v4(),
          text: '',
          questionId: questionId,
          isMultiline: false,
        );

  InputTextAnswer({
    required String id,
    required this.text,
    required this.isMultiline,
    required String questionId,
  }) : super(id, AnswerType.inputText, questionId);

  Map<String, dynamic> toDb() {
    return {
      'id': id,
      'type': type.name,
      'value_text': text,
      'is_multiline': isMultiline ? 1 : 0,
      'question_id': questionId,
    };
  }

  InputTextAnswer.fromDb(Map<String, dynamic> entry)
      : this(
          id: entry['id'],
          text: entry['value_text'],
          isMultiline: entry['is_multiline'] == 1,
          questionId: entry['question_id'],
        );

  @override
  Answer clone({bool generateNewGuid = false}) {
    final id = generateNewGuid ? const Uuid().v4() : this.id;
    return InputTextAnswer(
      id: id,
      text: text,
      questionId: questionId,
      isMultiline: isMultiline,
    );
  }
}
