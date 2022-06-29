import 'package:interviewer/models/question.dart';

class QuestionState {
  final Map<String, Question> byId;
  final List<String> all;

  QuestionState({required this.byId, required this.all});

  QuestionState copyWith({Map<String, Question>? byId, List<String>? all}) {
    return QuestionState(byId: byId ?? this.byId, all: all ?? this.all);
  }
}
