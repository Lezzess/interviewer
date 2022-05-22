import 'package:interviewer/models/answers/input_number_answer.dart';
import 'package:interviewer/models/question.dart';
import 'package:interviewer/utils/extensions/list_extensions.dart';

class SetInputNumberValueAction {
  Question question;
  InputNumberAnswer answer;
  double? value;

  SetInputNumberValueAction(this.question, this.answer, this.value);
}

List<Question> setInputNumberValue(
    List<Question> questions, SetInputNumberValueAction action) {
  final question = questions.firstWhere((q) => q == action.question);
  final answer = question.answer as InputNumberAnswer;

  final newAnswer = answer.copyWith(value: action.value);
  final newQuestion = question.copyWith(answer: newAnswer);
  final newQuestions = questions.ireplace(question, newQuestion);

  return newQuestions;
}
