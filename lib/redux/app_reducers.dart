import 'package:interviewer/redux/app_state.dart';
import 'package:interviewer/redux/questions/questions_reducer.dart';

AppState appReducer(AppState app, dynamic action) {
  return app.copyWith(questions: questionReducer(app.questions, action));
}
