import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:interviewer/models/question.dart';
import 'package:interviewer/pages/my_add_edit_question/my_add_edit_question.dart';
import 'package:interviewer/pages/my_add_edit_question/my_add_edit_question_arguments.dart';
import 'package:interviewer/pages/my_questions/widgets/my_question.dart';
import 'package:interviewer/pages/routes.dart';
import 'package:interviewer/redux/answers/selectors.dart';
import 'package:interviewer/redux/app/state.dart';
import 'package:interviewer/redux/questions/actions.dart';
import 'package:interviewer/redux/questions/selectors.dart';
import 'package:redux/redux.dart';

class MyQuestions extends StatelessWidget {
  const MyQuestions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Questions'),
      ),
      body: StoreConnector<AppState, _ViewModel>(
        converter: (store) => _ViewModel(
            questionIds: store.state.questions.all,
            editCallback: (questionId) =>
                _onEditClicked(context, questionId, store),
            removeCallback: (questionId) =>
                _onRemoveClicked(context, questionId, store)),
        builder: (context, viewmodel) => ListView.builder(
            shrinkWrap: true,
            // One more item for empty box in the bottom
            itemCount: viewmodel.questionIds.length + 1,
            itemBuilder: (context, index) => _listItem(
                viewmodel.questionIds,
                index,
                context,
                viewmodel.editCallback,
                viewmodel.removeCallback)),
      ),
      floatingActionButton: StoreConnector<AppState, VoidCallback>(
        converter: (store) => () => _onAddClicked(context, store),
        builder: (context, callback) => FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: callback,
        ),
      ),
    );
  }

  Widget _listItem(List<String> questionIds, int index, BuildContext context,
      OnEdit editCallback, OnRemove removeCallback) {
    if (index >= questionIds.length) {
      return Container(height: 80);
    }

    return MyQuestion(
      questionId: questionIds[index],
      onEdit: editCallback,
      onRemove: removeCallback,
    );
  }

  void _onAddClicked(BuildContext context, Store<AppState> store) async {
    final question = Question.empty();

    final args = MyAddEditQuestionArguments(question: question, asnwer: null);
    final addedQuestionAndAnswer =
        await Navigator.pushNamed(context, Routes.addQuestion, arguments: args);

    if (addedQuestionAndAnswer != null) {
      final tuple = addedQuestionAndAnswer as AddEditQuestionOutput;
      store.dispatch(
          AddQuestionAction(question: tuple.question, answer: tuple.answer));
    }
  }

  void _onEditClicked(
      BuildContext context, String questionId, Store<AppState> store) async {
    final question = selectQuestion(store.state.questions, questionId);
    final answer = selectAnswer(store.state.answers, question.answerId);

    final questionCopy = question.clone();
    final answerCopy = answer?.clone();

    final args =
        MyAddEditQuestionArguments(question: questionCopy, asnwer: answerCopy);
    final updatedQuestion = await Navigator.pushNamed(
        context, Routes.editQuestion,
        arguments: args);

    if (updatedQuestion != null) {
      final tuple = updatedQuestion as AddEditQuestionOutput;
      store.dispatch(UpdateQuestionAction(
          oldQuestionId: questionId,
          newQuestion: tuple.question,
          newAnswer: tuple.answer));
    }
  }

  void _onRemoveClicked(
      BuildContext context, String questionId, Store<AppState> store) {
    store.dispatch(RemoveQuestionAction(questionId));
  }
}

class _ViewModel {
  final List<String> questionIds;
  final OnEdit editCallback;
  final OnRemove removeCallback;

  _ViewModel(
      {required this.questionIds,
      required this.editCallback,
      required this.removeCallback});
}
