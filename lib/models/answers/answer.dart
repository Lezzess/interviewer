import 'package:interviewer/models/answers/answer_type.dart';

abstract class Answer {
  AnswerType type;
  String id;

  Answer(this.id, this.type);

  Answer clone();
}
