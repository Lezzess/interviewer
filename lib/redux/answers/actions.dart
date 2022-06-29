import 'package:interviewer/extensions/immutable_map.dart';
import 'package:interviewer/models/answers/input_number_answer.dart';
import 'package:interviewer/models/answers/input_text_answer.dart';
import 'package:interviewer/models/answers/select_value_answer.dart';
import 'package:interviewer/redux/answers/selectors.dart';
import 'package:interviewer/redux/answers/state.dart';
import 'package:interviewer/redux/app/actions.dart';

class SetSelectAnswerValueAction extends AppAction<AnswersState> {
  String answerId;
  SelectValue value;
  bool isSelected;

  SetSelectAnswerValueAction(this.answerId, this.value, this.isSelected);

  @override
  AnswersState handle(AnswersState state) {
    final answer = selectAnswer(state, answerId) as SelectValueAnswer;
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
    final newById = state.byId.ireplace(answerId, newAnswer);
    final newState = state.copyWith(byId: newById);

    return newState;
  }
}

class SetInputNumberValueAction extends AppAction<AnswersState> {
  String answerId;
  double? value;

  SetInputNumberValueAction(this.answerId, this.value);

  @override
  AnswersState handle(AnswersState state) {
    final answer = selectAnswer(state, answerId) as InputNumberAnswer;
    final newAnswer = answer.copyWith(value: value);
    final newById = state.byId.ireplace(answerId, newAnswer);
    final newState = state.copyWith(byId: newById);

    return newState;
  }
}

class SetInputTextValueAction extends AppAction<AnswersState> {
  String answerId;
  String text;

  SetInputTextValueAction(this.answerId, this.text);

  @override
  AnswersState handle(AnswersState state) {
    final answer = selectAnswer(state, answerId) as InputTextAnswer;
    final newAnswer = answer.copyWith(text: text);
    final newById = state.byId.ireplace(answerId, newAnswer);
    final newState = state.copyWith(byId: newById);

    return newState;
  }
}
