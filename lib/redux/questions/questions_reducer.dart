import 'package:interviewer/models/question.dart';
import 'package:interviewer/redux/app_actions.dart';

List<Question> questionReducer(List<Question> questions, dynamic action) {
  if (action is AppAction<List<Question>>) {
    return action.handle(questions);
  }

  return questions;
}
