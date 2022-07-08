import 'package:interviewer/models/question.dart';
import 'package:interviewer/redux/questions/state.dart';

List<String> selectCompanyQuestionIds(QuestionsState state, String companyId) {
  return state.companiesQuestions[companyId] ?? [];
}

List<Question> selectCompanyQuestions(QuestionsState state, String companyId) {
  final ids = state.companiesQuestions[companyId] ?? [];
  final questions = ids.map((id) => selectQuestion(state, id)).toList();

  return questions;
}

Question selectQuestion(QuestionsState state, String questionId) {
  final question = state.byId[questionId]!;
  return question;
}
