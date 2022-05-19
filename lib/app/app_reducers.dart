import 'package:interviewer/app/app_state.dart';
import 'package:interviewer/models/answers/select_value_answer.dart';
import 'package:interviewer/models/question.dart';

AppState appReducer(AppState state, dynamic action) {
  if (action is SetAnswerValueAction) {
    return setAnswerValue(state, action);
  }

  return state;
}

AppState setAnswerValue(AppState state, SetAnswerValueAction action) {
  final questions = state.questions;
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
  final newQuestions =
      questions.map((q) => q == action.question ? newQuestion : q).toList();

  return state.copyWith(questions: newQuestions);
}

class SetAnswerValueAction {
  Question question;
  SelectValueAnswer answer;
  SelectValue value;
  bool isSelected;

  SetAnswerValueAction(this.question, this.answer, this.value, this.isSelected);
}
