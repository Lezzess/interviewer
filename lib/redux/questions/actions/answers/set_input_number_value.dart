import 'package:interviewer/models/answers/input_number_answer.dart';
import 'package:interviewer/models/question.dart';
import 'package:interviewer/redux/app_actions.dart';
import 'package:interviewer/extensions/list_extensions.dart';

class SetInputNumberValueAction extends AppAction<List<Question>> {
  Question question;
  InputNumberAnswer answer;
  double? value;

  SetInputNumberValueAction(this.question, this.answer, this.value);

  @override
  List<Question> handle(List<Question> state) {
    final question = state.firstWhere((q) => q == this.question);
    final answer = question.answer as InputNumberAnswer;

    final newAnswer = answer.copyWith(value: value);
    final newQuestion = question.copyWith(answer: newAnswer);
    final newQuestions = state.ireplace(question, newQuestion);

    return newQuestions;
  }
}
