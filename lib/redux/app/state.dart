import 'package:interviewer/redux/answers/state.dart';
import 'package:interviewer/redux/questions/state.dart';

class AppState {
  final QuestionState questions;
  final AnswersState answers;

  AppState({required this.questions, required this.answers});

  AppState copyWith({QuestionState? questions, AnswersState? answers}) {
    return AppState(
        questions: questions ?? this.questions,
        answers: answers ?? this.answers);
  }
}
