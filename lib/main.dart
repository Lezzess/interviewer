import 'package:flutter/material.dart';
import 'package:interviewer/db/db.dart';
import 'package:interviewer/pages/my_add_edit_question/my_add_edit_question.dart';
import 'package:interviewer/pages/my_add_edit_question/my_add_edit_question_arguments.dart';
import 'package:interviewer/pages/my_companies/my_companies.dart';
import 'package:interviewer/pages/my_folders/my_folders.dart';
import 'package:interviewer/pages/my_questions/my_questions.dart';
import 'package:interviewer/pages/my_questions/my_questions_arguments.dart';
import 'package:interviewer/pages/routes.dart';
import 'package:interviewer/states/app_state.dart';
import 'package:interviewer/states/app_state_mock.dart';
import 'package:interviewer/states/companies_state.dart';
import 'package:interviewer/states/folders_state.dart';
import 'package:interviewer/states/questions_state.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await initializeDatabase();
  // await seedData();

  final appState = createMock();
  // final appState = await loadState();
  runApp(MyApp(
    state: appState,
  ));
}

class MyApp extends StatelessWidget {
  final AppState state;

  const MyApp({super.key, required this.state});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // const black = Color(0xff0f0a0a);
    const red = Color(0xffff0054);
    // const white = Color(0xffe7ecef);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CompaniesState>(
          create: (_) => CompaniesState(state.companies),
        ),
        ChangeNotifierProvider<FoldersState>(
          create: (_) => FoldersState(state.folders),
        ),
        ChangeNotifierProvider<QuestionsState>(
          create: (_) => QuestionsState(state.questions),
        ),
      ],
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
        builder = (ctx) => MyAddEditQuestion(question: args.question);
        break;
      case Routes.editQuestion:
        final args = settings.arguments as MyAddEditQuestionArguments;
        builder = (ctx) => MyAddEditQuestion(question: args.question);
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
