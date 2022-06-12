import 'package:interviewer/models/answers/input_text_answer.dart';
import 'package:interviewer/models/question.dart';
import 'package:interviewer/utils/extensions/list_extensions.dart';

class SetInputTextValueAction {
  Question question;
  InputTextAnswer answer;
  String text;

  SetInputTextValueAction(this.question, this.answer, this.text);
}

List<Question> setInputText(
    List<Question> questions, SetInputTextValueAction action) {
  final question = questions.firstWhere((q) => q == action.question);
  final answer = question.answer as InputTextAnswer;

  final newAnswer = answer.copyWith(text: action.text);
  final newQuestion = question.copyWith(answer: newAnswer);
  final newQuestions = questions.ireplace(question, newQuestion);

  return newQuestions;
}
