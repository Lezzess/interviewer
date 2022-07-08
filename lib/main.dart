import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:interviewer/pages/my_add_edit_question/my_add_edit_question.dart';
import 'package:interviewer/pages/my_add_edit_question/my_add_edit_question_arguments.dart';
import 'package:interviewer/pages/my_companies/my_companies.dart';
import 'package:interviewer/pages/my_folders/my_folders.dart';
import 'package:interviewer/pages/my_questions/my_questions.dart';
import 'package:interviewer/pages/my_questions/my_questions_arguments.dart';
import 'package:interviewer/pages/routes.dart';
import 'package:interviewer/redux/app/reducers.dart';
import 'package:interviewer/redux/app/state.dart';
import 'package:interviewer/redux/app/state_mock.dart';
import 'package:redux/redux.dart';

void main() {
  final appState = createMock();
  final store = Store<AppState>(appReducer, initialState: appState);
  runApp(MyApp(
    state: appState,
    store: store,
  ));
}

class MyApp extends StatelessWidget {
  final AppState state;
  final Store<AppState> store;

  const MyApp({super.key, required this.state, required this.store});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // const black = Color(0xff0f0a0a);
    const red = Color(0xffff0054);
    // const white = Color(0xffe7ecef);
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSwatch().copyWith(secondary: red),
            // colorScheme: const ColorScheme.light(
            // secondary: red,
            // ),
            // colorScheme: const ColorScheme(
            //     brightness: Brightness.dark,
            //     primary: black,
            //     onPrimary: white,
            //     secondary: red,
            //     onSecondary: white,
            //     error: red,
            //     onError: white,
            //     background: white,
            //     onBackground: black,
            //     surface: whitePure,
            //     onSurface: black),
            primarySwatch: Colors.blue,
            toggleableActiveColor: Colors.red),
        initialRoute: Routes.companies,
        onGenerateRoute: _onGenerateRoute,
      ),
    );
  }

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    Widget Function(BuildContext) builder;

    switch (settings.name) {
      case Routes.questions:
        final args = settings.arguments as MyQuestionsArguments;
        builder = (ctx) => MyQuestions(companyId: args.companyId);
        break;
      case Routes.addQuestion:
        final args = settings.arguments as MyAddEditQuestionArguments;
        builder = (ctx) => MyAddEditQuestion(
              question: args.question,
              answer: args.asnwer,
              folder: args.folder,
              companyId: args.companyId,
            );
        break;
      case Routes.editQuestion:
        final args = settings.arguments as MyAddEditQuestionArguments;
        builder = (ctx) => MyAddEditQuestion(
              question: args.question,
              answer: args.asnwer,
              folder: args.folder,
              companyId: args.companyId,
            );
        break;
      case Routes.folders:
        builder = (ctx) => const MyFolders();
        break;
      case Routes.companies:
        builder = (ctx) => const MyCompanies();
        break;
      default:
        return null;
    }

    return MaterialPageRoute(builder: builder, settings: settings);
  }
}
