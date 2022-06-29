import 'package:interviewer/models/answers/answer.dart';
import 'package:interviewer/redux/answers/state.dart';

Answer? selectAnswer(AnswersState state, String? id) {
  return id == null ? null : state.byId[id]!;
}

Answer? selectEditedAnswer(AnswersState state, String? id) {
  return id == null ? null : state.byId[id]!;
}
