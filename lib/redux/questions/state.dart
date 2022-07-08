import 'package:interviewer/models/question.dart';

class QuestionsState {
  final Map<String, Question> byId;
  final List<String> all;
  final Map<String, List<String>> companiesQuestions;

  QuestionsState({
    required this.byId,
    required this.all,
    required this.companiesQuestions,
  });

  QuestionsState copyWith({
    Map<String, Question>? byId,
    List<String>? all,
    Map<String, List<String>>? companiesQuestions,
  }) {
    return QuestionsState(
      byId: byId ?? this.byId,
      all: all ?? this.all,
      companiesQuestions: companiesQuestions ?? this.companiesQuestions,
    );
  }
}
