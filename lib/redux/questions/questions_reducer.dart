import 'package:interviewer/models/question.dart';
import 'package:interviewer/redux/questions/answers/set_input_number_value.dart';
import 'package:interviewer/redux/questions/answers/set_input_text_value.dart';
import 'package:interviewer/redux/questions/answers/set_select_answer_value.dart';

List<Question> questionReducer(List<Question> questions, dynamic action) {
  if (action is SetSelectAnswerValueAction) {
    return setSelectAnswerValue(questions, action);
  } else if (action is SetInputNumberValueAction) {
    return setInputNumberValue(questions, action);
  } else if (action is SetInputTextValueAction) {
    return setInputText(questions, action);
  }

  return questions;
}
