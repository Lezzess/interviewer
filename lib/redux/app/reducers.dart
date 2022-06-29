import 'package:interviewer/redux/answers/state.dart';
import 'package:interviewer/redux/app/actions.dart';
import 'package:interviewer/redux/app/state.dart';
import 'package:interviewer/redux/questions/state.dart';

AppState appReducer(AppState state, dynamic action) {
  if (action is AppAction<AppState>) {
    return action.handle(state);
  }

  return state.copyWith(
      questions: questionReducer(state.questions, action),
      answers: answersReducer(state.answers, action));
}

QuestionState questionReducer(QuestionState questions, dynamic action) {
  if (action is AppAction<QuestionState>) {
    return action.handle(questions);
  }

  return questions;
}

AnswersState answersReducer(AnswersState answers, dynamic action) {
  if (action is AppAction<AnswersState>) {
    return action.handle(answers);
  }

  return answers;
}
