import 'package:interviewer/models/answers/input_text_answer.dart';
import 'package:interviewer/models/question.dart';
import 'package:interviewer/redux/app_actions.dart';
import 'package:interviewer/utils/extensions/list_extensions.dart';

class SetInputTextValueAction extends AppAction<List<Question>> {
  Question question;
  InputTextAnswer answer;
  String text;

  SetInputTextValueAction(this.question, this.answer, this.text);

  @override
  List<Question> handle(List<Question> state) {
    final question = state.firstWhere((q) => q == this.question);
    final answer = question.answer as InputTextAnswer;

    final newAnswer = answer.copyWith(text: text);
    final newQuestion = question.copyWith(answer: newAnswer);
    final newQuestions = state.ireplace(question, newQuestion);

    return newQuestions;
  }
}
