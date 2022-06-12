import 'package:interviewer/models/answers/answer_type.dart';

abstract class Answer {
  AnswerType type;

  Answer(this.type);

  Answer clone();
}
