import 'package:interviewer/models/question.dart';

class AppState {
  final List<Question> questions;

  AppState({required this.questions});

  AppState copyWith({List<Question>? questions}) {
    return AppState(questions: questions ?? this.questions);
  }
}
