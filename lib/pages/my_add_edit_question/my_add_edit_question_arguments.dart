import 'package:interviewer/models/answers/answer.dart';
import 'package:interviewer/models/question.dart';

class MyAddEditQuestionArguments {
  final Question question;
  final Answer? asnwer;

  MyAddEditQuestionArguments({required this.question, required this.asnwer});
}
