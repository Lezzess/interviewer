import 'package:interviewer/models/question.dart';
import 'package:interviewer/redux/questions/state.dart';

List<Question> selectAllQuestions(QuestionState state) {
  final ids = state.all;
  final questions = ids.map((id) => state.byId[id]!).toList();

  return questions;
}

Question selectQuestion(QuestionState state, String questionId) {
  final question = state.byId[questionId]!;
  return question;
}
