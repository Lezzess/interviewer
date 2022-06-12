import 'package:interviewer/models/question.dart';
import 'package:interviewer/redux/app_actions.dart';
import 'package:interviewer/extensions/list_extensions.dart';

class EditQuestionAction extends AppAction<List<Question>> {
  Question oldQuestion;
  Question newQuestion;

  EditQuestionAction({required this.oldQuestion, required this.newQuestion});

  @override
  List<Question> handle(List<Question> state) {
    final newQuestions = state.ireplace(oldQuestion, newQuestion);
    return newQuestions;
  }
}
