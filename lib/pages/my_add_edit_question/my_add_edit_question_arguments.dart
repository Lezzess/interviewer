import 'package:interviewer/models/answers/answer.dart';
import 'package:interviewer/models/folder.dart';
import 'package:interviewer/models/question.dart';

class MyAddEditQuestionArguments {
  final Question? question;
  final Answer? asnwer;
  final Folder? folder;
  final String companyId;

  MyAddEditQuestionArguments({
    this.question,
    this.asnwer,
    this.folder,
    required this.companyId,
  });
}
