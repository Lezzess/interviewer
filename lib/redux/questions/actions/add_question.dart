import 'package:interviewer/models/question.dart';
import 'package:interviewer/redux/app_actions.dart';
import 'package:interviewer/utils/extensions/list_extensions.dart';

class AddQuestionAction extends AppAction<List<Question>> {
  Question question;

  AddQuestionAction(this.question);

  @override
  List<Question> handle(List<Question> state) {
    final newQuestions = state.iadd(question);
    return newQuestions;
  }
}
