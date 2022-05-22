import 'package:interviewer/models/question.dart';
import 'package:interviewer/redux/app_state.dart';
import 'package:redux/redux.dart';

List<Question> selectAllQuestions(Store<AppState> store) {
  return store.state.questions;
}
