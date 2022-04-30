import 'package:flutter/material.dart';
import 'package:interviewer/pages/my_questions/my_questions.dart';
import 'package:interviewer/app/app_state.dart';
import 'package:provider/provider.dart';

void main() {
  final appState = AppState();
  runApp(MyApp(
    state: appState,
  ));
}

class MyApp extends StatelessWidget {
  final AppState state;

  const MyApp({Key? key, required this.state}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const black = Color(0xff0f0a0a);
    const red = Color(0xffff0054);
    const white = Color(0xffe7ecef);
    return ChangeNotifierProvider.value(
      value: state,
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
