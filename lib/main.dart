import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:interviewer/models/answers/input_number_answer.dart';
import 'package:interviewer/models/answers/input_text_answer.dart';
import 'package:interviewer/models/answers/select_value_answer.dart';
import 'package:interviewer/models/question.dart';
import 'package:interviewer/pages/my_questions/my_questions.dart';
import 'package:interviewer/redux/app_reducers.dart';
import 'package:interviewer/redux/app_state.dart';
import 'package:redux/redux.dart';
import 'package:uuid/uuid.dart';

List<Question> questionsMock = <Question>[
  Question(
      id: const Uuid().v4(),
      text: 'First',
      answer: SelectValueAnswer(
          id: const Uuid().v4(),
          values: [
            SelectValue(id: const Uuid().v4(), value: 'One', isSelected: false),
            SelectValue(id: const Uuid().v4(), value: 'Two', isSelected: false),
            SelectValue(
                id: const Uuid().v4(), value: 'Three', isSelected: false)
          ],
          isMultipleSelect: true)),
  Question(
      id: const Uuid().v4(),
      text: 'Second',
      answer: SelectValueAnswer(
          id: const Uuid().v4(),
          values: [
            SelectValue(id: const Uuid().v4(), value: 'Four', isSelected: false)
          ],
          isMultipleSelect: true)),
  Question(
      id: const Uuid().v4(),
      text: 'Third',
      answer: SelectValueAnswer(
          id: const Uuid().v4(),
          values: [
            SelectValue(
                id: const Uuid().v4(), value: 'Five', isSelected: false),
            SelectValue(id: const Uuid().v4(), value: 'Six', isSelected: false),
            SelectValue(
                id: const Uuid().v4(), value: 'Seven', isSelected: false)
          ],
          isMultipleSelect: false)),
  Question(
      id: const Uuid().v4(),
      text: 'Forth',
      answer: InputNumberAnswer(id: const Uuid().v4(), value: 8.25)),
  Question(
      id: const Uuid().v4(),
      text: 'Forth.One',
      answer: InputNumberAnswer(id: const Uuid().v4(), value: null)),
  Question(
      id: const Uuid().v4(),
      text: 'Fifth',
      answer: InputTextAnswer(
          id: const Uuid().v4(), text: 'Some text in this answer')),
  Question(
      id: const Uuid().v4(),
      text: 'Fifth.One',
      answer: InputTextAnswer(id: const Uuid().v4(), text: '')),
];

void main() {
  final appState = AppState(questions: questionsMock);
  final store = Store<AppState>(appReducer, initialState: appState);
  runApp(MyApp(
    state: appState,
    store: store,
  ));
}

class MyApp extends StatelessWidget {
  final AppState state;
  final Store<AppState> store;

  const MyApp({Key? key, required this.state, required this.store})
      : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const black = Color(0xff0f0a0a);
    const red = Color(0xffff0054);
    const white = Color(0xffe7ecef);
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            colorScheme: const ColorScheme(
                brightness: Brightness.light,
                primary: black,
                onPrimary: white,
                secondary: red,
                onSecondary: white,
                error: red,
                onError: white,
                background: white,
                onBackground: black,
                surface: white,
                onSurface: black),
            primarySwatch: Colors.blue,
            toggleableActiveColor: red),
        home: const MyQuestions(),
      ),
    );
  }
}
