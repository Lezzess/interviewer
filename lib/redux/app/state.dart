import 'package:interviewer/redux/answers/state.dart';
import 'package:interviewer/redux/companies/state.dart';
import 'package:interviewer/redux/folders/state.dart';
import 'package:interviewer/redux/questions/state.dart';

class AppState {
  final QuestionsState questions;
  final AnswersState answers;
  final FoldersState folders;
  final CompaniesState companies;

  AppState({
    required this.questions,
    required this.answers,
    required this.folders,
    required this.companies,
  });

  AppState copyWith({
    QuestionsState? questions,
    AnswersState? answers,
    FoldersState? folders,
    CompaniesState? companies,
  }) {
    return AppState(
      questions: questions ?? this.questions,
      answers: answers ?? this.answers,
      folders: folders ?? this.folders,
      companies: companies ?? this.companies,
    );
  }
}
