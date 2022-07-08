import 'package:interviewer/redux/answers/state.dart';
import 'package:interviewer/redux/app/actions.dart';
import 'package:interviewer/redux/app/state.dart';
import 'package:interviewer/redux/companies/state.dart';
import 'package:interviewer/redux/folders/state.dart';
import 'package:interviewer/redux/questions/state.dart';

AppState appReducer(AppState state, dynamic action) {
  if (action is AppAction<AppState>) {
    return action.handle(state);
  }

  return state.copyWith(
    questions: questionsReducer(state.questions, action),
    answers: answersReducer(state.answers, action),
    folders: foldersReducer(state.folders, action),
    companies: companiesReducer(state.companies, action),
  );
}

QuestionsState questionsReducer(QuestionsState questions, dynamic action) {
  if (action is AppAction<QuestionsState>) {
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

FoldersState foldersReducer(FoldersState folders, dynamic action) {
  if (action is AppAction<FoldersState>) {
    return action.handle(folders);
  }

  return folders;
}

CompaniesState companiesReducer(CompaniesState companies, dynamic action) {
  if (action is AppAction<CompaniesState>) {
    return action.handle(companies);
  }

  return companies;
}
