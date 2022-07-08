import 'package:interviewer/extensions/immutable_list.dart';
import 'package:interviewer/extensions/immutable_map.dart';
import 'package:interviewer/models/answers/answer.dart';
import 'package:interviewer/models/folder.dart';
import 'package:interviewer/models/question.dart';
import 'package:interviewer/redux/app/actions.dart';
import 'package:interviewer/redux/app/state.dart';
import 'package:interviewer/redux/companies/selectors.dart';
import 'package:interviewer/redux/questions/selectors.dart';
import 'package:interviewer/redux/questions/state.dart';
import 'package:uuid/uuid.dart';

class AddQuestionAction extends AppAction<AppState> {
  final Question question;
  final Answer? answer;
  final Folder? folder;

  AddQuestionAction({
    required this.question,
    required this.answer,
    required this.folder,
  });

  @override
  AppState handle(AppState state) {
    final newByIdQuestions = state.questions.byId.iadd(question.id, question);
    final newAllQuestions = state.questions.all.iadd(question.id);

    final companiesQuestions = state.questions.companiesQuestions;
    var questionList = companiesQuestions[question.companyId];
    questionList ??= [];
    questionList = questionList.iadd(question.id);
    final newCompaniesQuestions = companiesQuestions.ireplace(
      question.companyId,
      questionList,
    );

    final newStateQuestions = state.questions.copyWith(
      byId: newByIdQuestions,
      all: newAllQuestions,
      companiesQuestions: newCompaniesQuestions,
    );

    var newByIdAnswers = state.answers.byId;
    if (answer != null) {
      question.answerId = answer!.id;
      newByIdAnswers = state.answers.byId.iadd(answer!.id, answer!);
    }
    final newStateAnswers = state.answers.copyWith(byId: newByIdAnswers);

    if (folder != null) {
      question.folderId = folder!.id;
    }

    final newState = state.copyWith(
      questions: newStateQuestions,
      answers: newStateAnswers,
    );
    return newState;
  }
}

class UpdateQuestionAction extends AppAction<AppState> {
  final String oldQuestionId;
  final Question newQuestion;
  final Answer? newAnswer;
  final Folder? newFolder;

  UpdateQuestionAction({
    required this.oldQuestionId,
    required this.newQuestion,
    required this.newAnswer,
    required this.newFolder,
  });

  @override
  AppState handle(AppState state) {
    final oldQuestion = selectQuestion(state.questions, oldQuestionId);

    var newByIdQuestions = state.questions.byId;
    newByIdQuestions = newByIdQuestions.iremove(oldQuestion.id);
    newByIdQuestions = newByIdQuestions.iadd(newQuestion.id, newQuestion);
    var newAllQuestions = state.questions.all;
    newAllQuestions = newAllQuestions.iremove(oldQuestion.id);
    newAllQuestions = newAllQuestions.iadd(oldQuestion.id);

    var newByIdAnswers = state.answers.byId;
    if (oldQuestion.answerId != null) {
      newByIdAnswers = newByIdAnswers.iremove(oldQuestion.answerId!);
    }
    if (newAnswer != null) {
      newQuestion.answerId = newAnswer!.id;
      newByIdAnswers = newByIdAnswers.iadd(newAnswer!.id, newAnswer!);
    }

    if (newFolder != null) {
      newQuestion.folderId = newFolder!.id;
    }

    final newStateQuestions =
        state.questions.copyWith(byId: newByIdQuestions, all: newAllQuestions);
    final newStateAnswers = state.answers.copyWith(byId: newByIdAnswers);

    final newState =
        state.copyWith(questions: newStateQuestions, answers: newStateAnswers);
    return newState;
  }
}

class RemoveQuestionAction extends AppAction<QuestionsState> {
  final String questionId;

  RemoveQuestionAction(this.questionId);

  @override
  QuestionsState handle(QuestionsState state) {
    final question = selectQuestion(state, questionId);

    final newById = state.byId.iremove(question.id);
    final newAll = state.all.iremove(question.id);

    final companiesQuestions = state.companiesQuestions;
    final companyQuestions = state.companiesQuestions[question.companyId]!;
    final newCompanyQuestions = companyQuestions.iremove(question.id);
    final newCompaniesQuestions = companiesQuestions.ireplace(
      question.companyId,
      newCompanyQuestions,
    );

    final newState = state.copyWith(
      byId: newById,
      all: newAll,
      companiesQuestions: newCompaniesQuestions,
    );

    return newState;
  }
}

class FillQuestionsFromTemplateAction extends AppAction<AppState> {
  final String companyId;

  FillQuestionsFromTemplateAction(this.companyId);

  @override
  AppState handle(AppState state) {
    final templateCompany = selectTemplateCompany(state.companies);
    final templateQuestions =
        selectCompanyQuestions(state.questions, templateCompany.id);

    final copiedQuestions = templateQuestions
        .map((question) => question.copyWith(
              id: const Uuid().v4(),
              companyId: companyId,
            ))
        .toList();

    var newByIdQuestions = state.questions.byId;
    var newAllQuestions = state.questions.all;
    var newCompaniesQuestions = state.questions.companiesQuestions;
    var newCompanyQuestions = <String>[];
    for (var question in copiedQuestions) {
      newByIdQuestions = newByIdQuestions.iadd(question.id, question);
      newAllQuestions = newAllQuestions.iadd(question.id);
      newCompanyQuestions.add(question.id);
    }
    newCompaniesQuestions = newCompaniesQuestions.iadd(
      companyId,
      newCompanyQuestions,
    );

    final newStateQuestions = state.questions.copyWith(
      byId: newByIdQuestions,
      all: newAllQuestions,
      companiesQuestions: newCompaniesQuestions,
    );
    final newState = state.copyWith(questions: newStateQuestions);

    return newState;
  }
}

class AddQuestionNoteAction extends AppAction<QuestionsState> {
  final String questionId;
  final String noteText;

  AddQuestionNoteAction(this.questionId, this.noteText);

  @override
  QuestionsState handle(QuestionsState state) {
    final question = selectQuestion(state, questionId);
    final newQuestion = question.copyWith(note: noteText);

    final newById = state.byId.ireplace(question.id, newQuestion);
    final newState = state.copyWith(byId: newById);

    print('Updated note to $noteText');

    return newState;
  }
}
