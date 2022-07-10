import 'package:interviewer/models/company.dart';
import 'package:interviewer/models/folder.dart';
import 'package:interviewer/models/question.dart';
import 'package:interviewer/repositories/companies.dart' as companies;
import 'package:interviewer/repositories/folders.dart' as folders;
import 'package:interviewer/repositories/questions.dart' as questions;

Future<AppState> loadState() async {
  final allCompanies = await companies.getAll();
  final allFolders = await folders.getAll();
  final allQuestions = await questions.getAll();

  final appState = AppState(
    questions: allQuestions,
    companies: allCompanies,
    folders: allFolders,
  );
  return appState;
}

class AppState {
  final List<Company> companies;
  final List<Folder> folders;
  final List<Question> questions;

  AppState({
    required this.companies,
    required this.folders,
    required this.questions,
  });
}
