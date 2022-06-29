import 'package:interviewer/extensions/immutable_list.dart';
import 'package:interviewer/extensions/immutable_map.dart';
import 'package:interviewer/models/answers/answer.dart';
import 'package:interviewer/models/question.dart';
import 'package:interviewer/redux/app/actions.dart';
import 'package:interviewer/redux/app/state.dart';
import 'package:interviewer/redux/questions/selectors.dart';
import 'package:interviewer/redux/questions/state.dart';

class AddQuestionAction extends AppAction<AppState> {
  final Question question;
  final Answer? answer;

  AddQuestionAction({required this.question, required this.answer});

  @override
  AppState handle(AppState state) {
    final newByIdQuestions = state.questions.byId.iadd(question.id, question);
    final newAllQuestions = state.questions.all.iadd(question.id);
    final newStateQuestions =
        state.questions.copyWith(byId: newByIdQuestions, all: newAllQuestions);

    var newByIdAnswers = state.answers.byId;
    if (answer != null) {
      question.answerId = answer!.id;
      newByIdAnswers = state.answers.byId.iadd(answer!.id, answer!);
    }
    final newStateAnswers = state.answers.copyWith(byId: newByIdAnswers);

    final newState =
        state.copyWith(questions: newStateQuestions, answers: newStateAnswers);
    return newState;
  }
}

class UpdateQuestionAction extends AppAction<AppState> {
  final String oldQuestionId;
  Question newQuestion;
  final Answer? newAnswer;

  UpdateQuestionAction(
      {required this.oldQuestionId,
      required this.newQuestion,
      required this.newAnswer});

  @override
  AppState handle(AppState state) {
    final oldQuestion = selectQuestion(state.questions, oldQuestionId);

    var newByIdQuestions = state.questions.byId;
    newByIdQuestions = newByIdQuestions.iremove(oldQuestion.id);
    newByIdQuestions = newByIdQuestions.iadd(newQuestion.id, newQuestion);
    var newAllQuestions = state.questions.all;
    newAllQuestions = newAllQuestions.iremvoe(oldQuestion.id);
    newAllQuestions = newAllQuestions.iadd(oldQuestion.id);

    var newByIdAnswers = state.answers.byId;
    if (oldQuestion.answerId != null) {
      newByIdAnswers = newByIdAnswers.iremove(oldQuestion.answerId!);
    }
    if (newAnswer != null) {
      newQuestion.answerId = newAnswer!.id;
      newByIdAnswers = newByIdAnswers.iadd(newAnswer!.id, newAnswer!);
    }

    final newStateQuestions =
        state.questions.copyWith(byId: newByIdQuestions, all: newAllQuestions);
    final newStateAnswers = state.answers.copyWith(byId: newByIdAnswers);

    final newState =
        state.copyWith(questions: newStateQuestions, answers: newStateAnswers);
    return newState;
  }
}

class RemoveQuestionAction extends AppAction<QuestionState> {
  final String questionId;

  RemoveQuestionAction(this.questionId);

  @override
  QuestionState handle(QuestionState state) {
    final newById = state.byId.iremove(questionId);
    final newAll = state.all.iremvoe(questionId);
    final newState = state.copyWith(byId: newById, all: newAll);

    return newState;
  }
}
