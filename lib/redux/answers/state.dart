import 'package:interviewer/models/answers/answer.dart';

class AnswersState {
  final Map<String, Answer> byId;

  AnswersState(this.byId);

  AnswersState copyWith({Map<String, Answer>? byId}) {
    return AnswersState(byId ?? this.byId);
  }
}
