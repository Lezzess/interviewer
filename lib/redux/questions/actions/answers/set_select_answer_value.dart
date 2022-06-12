import 'package:interviewer/models/answers/select_value_answer.dart';
import 'package:interviewer/models/question.dart';
import 'package:interviewer/redux/app_actions.dart';
import 'package:interviewer/extensions/list_extensions.dart';

class SetSelectAnswerValueAction extends AppAction<List<Question>> {
  Question question;
  SelectValueAnswer answer;
  SelectValue value;
  bool isSelected;

  SetSelectAnswerValueAction(
      this.question, this.answer, this.value, this.isSelected);

  @override
  List<Question> handle(List<Question> state) {
    final question = state.firstWhere((q) => q == this.question);
    final answer = question.answer as SelectValueAnswer;
    final values = answer.values;

    final newValues = values.map((v) {
      if (v == value) {
        return v.copyWith(isSelected: isSelected);
      }

      if (!answer.isMultipleSelect && v != value && v.isSelected) {
        return v.copyWith(isSelected: false);
      }

      return v;
    }).toList();
    final newAnswer = answer.copyWith(values: newValues);
    final newQuestion = question.copyWith(answer: newAnswer);
    final newQuestions = state.ireplace(question, newQuestion);

    return newQuestions;
  }
}
