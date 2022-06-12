import 'package:interviewer/models/question.dart';
import 'package:interviewer/utils/extensions/list_extensions.dart';

class AddQuestionAction {
  Question question;

  AddQuestionAction(this.question);
}

List<Question> addQuestion(List<Question> questions, AddQuestionAction action) {
  final newQuestions = questions.iadd(action.question);
  return newQuestions;
}
