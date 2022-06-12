import 'package:interviewer/models/question.dart';
import 'package:interviewer/redux/app_actions.dart';
import 'package:interviewer/extensions/list_extensions.dart';

class RemoveQuestionAction extends AppAction<List<Question>> {
  Question question;

  RemoveQuestionAction(this.question);

  @override
  List<Question> handle(List<Question> state) {
    final newQuestions = state.iremvoe(question);
    return newQuestions;
  }
}
