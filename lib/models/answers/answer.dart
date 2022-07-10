import 'package:interviewer/models/answers/answer_type.dart';

abstract class Answer {
  AnswerType type;
  String id;
  String questionId;

  Answer(this.id, this.type, this.questionId);

  Answer clone({bool generateNewGuid = false});
}
