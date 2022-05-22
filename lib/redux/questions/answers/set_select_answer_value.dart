import 'package:interviewer/models/answers/select_value_answer.dart';
import 'package:interviewer/models/question.dart';
import 'package:interviewer/utils/extensions/list_extensions.dart';

class SetSelectAnswerValueAction {
  Question question;
  SelectValueAnswer answer;
  SelectValue value;
  bool isSelected;

  SetSelectAnswerValueAction(
      this.question, this.answer, this.value, this.isSelected);
}

List<Question> setSelectAnswerValue(
    List<Question> questions, SetSelectAnswerValueAction action) {
  final question = questions.firstWhere((q) => q == action.question);
  final answer = question.answer as SelectValueAnswer;
  final values = answer.values;

  final newValues = values.map((v) {
    if (v == action.value) {
      return v.copyWith(isSelected: action.isSelected);
    }

    if (!answer.isMultipleSelect && v != action.value && v.isSelected) {
      return v.copyWith(isSelected: false);
    }

    return v;
  }).toList();
  final newAnswer = answer.copyWith(values: newValues);
  final newQuestion = question.copyWith(answer: newAnswer);
  final newQuestions = questions.ireplace(question, newQuestion);

  return newQuestions;
}
