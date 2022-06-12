import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:interviewer/models/answers/input_text_answer.dart';
import 'package:interviewer/models/answers/input_number_answer.dart';
import 'package:interviewer/models/answers/select_value_answer.dart';
import 'package:interviewer/models/question.dart';
import 'package:interviewer/pages/my_add_edit_question/my_add_edit_question_arguments.dart';
import 'package:interviewer/pages/my_questions/widgets/my_input_number_answer.dart';
import 'package:interviewer/pages/my_questions/widgets/my_input_text_answer.dart';
import 'package:interviewer/pages/my_questions/widgets/my_select_value_answer.dart';
import 'package:interviewer/pages/routes.dart';
import 'package:interviewer/redux/app_state.dart';
import 'package:interviewer/redux/questions/actions/add_question.dart';
import 'package:interviewer/redux/questions/actions/answers/set_input_number_value.dart';
import 'package:interviewer/redux/questions/actions/answers/set_input_text_value.dart';
import 'package:interviewer/redux/questions/actions/answers/set_select_answer_value.dart';
import 'package:interviewer/redux/questions/actions/edit_question.dart';
import 'package:interviewer/redux/questions/actions/remove_question.dart';
import 'package:interviewer/redux/questions/questions_selectors.dart';
import 'package:interviewer/styles/app_styles.dart';
import 'package:redux/redux.dart';

class MyQuestions extends StatelessWidget {
  const MyQuestions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Questions'),
      ),
      body: StoreConnector<AppState, List<Question>>(
        converter: selectAllQuestions,
        builder: (context, questions) => ListView.builder(
            shrinkWrap: true,
            // One more item for empty box in the bottom
            itemCount: questions.length + 1,
            itemBuilder: (context, index) =>
                StoreConnector<AppState, _Callbacks>(
                    converter: (store) => _Callbacks(
                        editCallback: (question) =>
                            _onEditClicked(context, question, store),
                        removeCallback: (question) =>
                            _onRemoveClicked(context, question, store)),
                    builder: (context, callbacks) =>
                        _listItem(questions, index, context, callbacks))),
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

  Widget _listItem(List<Question> questions, int index, BuildContext context,
      _Callbacks callbacks) {
    return index < questions.length
        ? _MyQuestion(
            question: questions[index],
            onEdit: callbacks.editCallback,
            onRemove: callbacks.removeCallback,
          )
        : Container(
            height: 80,
          );
  }

  void _onAddClicked(BuildContext context, Store<AppState> store) async {
    final addedQuestion =
        await Navigator.pushNamed(context, Routes.addQuestion);
    if (addedQuestion != null) {
      store.dispatch(AddQuestionAction(addedQuestion as Question));
    }
  }

  void _onEditClicked(
      BuildContext context, Question question, Store<AppState> store) async {
    final args = MyAddEditQuestionArguments(question);
    final updatedQuestion = await Navigator.pushNamed(
        context, Routes.editQuestion,
        arguments: args);
    if (updatedQuestion != null) {
      store.dispatch(EditQuestionAction(
          oldQuestion: question, newQuestion: updatedQuestion as Question));
    }
  }

  void _onRemoveClicked(
      BuildContext context, Question question, Store<AppState> store) {
    store.dispatch(RemoveQuestionAction(question));
  }
}

typedef OnEdit = void Function(Question question);
typedef OnRemove = void Function(Question question);

class _MyQuestion extends StatelessWidget {
  final Question question;
  final OnEdit? onEdit;
  final OnRemove? onRemove;

  const _MyQuestion(
      {super.key, required this.question, this.onEdit, this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 5),
        child: Column(
          children: [
            _questionHeader(context, question),
            _answer(context, question)
          ],
        ),
      ),
    );
  }

  Widget _questionHeader(BuildContext context, Question question) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom:
                  BorderSide(color: Theme.of(context).colorScheme.primary))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  question.text,
                  style: Theme.of(context).textTheme.questionText,
                ),
              ),
            ),
          ),
          IconButton(
            padding: const EdgeInsets.fromLTRB(5, 13, 5, 5),
            constraints: const BoxConstraints(),
            icon: Icon(
              Icons.edit,
              color: Theme.of(context).unselectedWidgetColor,
            ),
            onPressed: () => onEdit?.call(question),
          ),
          IconButton(
            padding: const EdgeInsets.fromLTRB(5, 13, 5, 5),
            constraints: const BoxConstraints(),
            icon: Icon(
              Icons.delete,
              color: Theme.of(context).unselectedWidgetColor,
            ),
            onPressed: () => onRemove?.call(question),
          )
        ],
      ),
    );
  }

  Widget _answer(BuildContext context, Question question) {
    final answer = question.answer;
    if (answer is SelectValueAnswer) {
      return StoreConnector<AppState, OnAnswerSelected>(
        converter: (store) => (answer, value, isSelected) => store.dispatch(
            SetSelectAnswerValueAction(question, answer, value, isSelected)),
        builder: (context, callback) =>
            MySelectValueAnswer(answer: answer, onChanged: callback),
      );
    } else if (answer is InputNumberAnswer) {
      return StoreConnector<AppState, OnNumberChanged>(
        converter: (store) => (answer, newValue) => store
            .dispatch(SetInputNumberValueAction(question, answer, newValue)),
        builder: (context, callback) => _answerInputNumber(answer, callback),
      );
    } else if (answer is InputTextAnswer) {
      return StoreConnector<AppState, OnTextChanged>(
        converter: (store) => (answer, newText) =>
            store.dispatch(SetInputTextValueAction(question, answer, newText)),
        builder: (context, callback) => _answerInputText(answer, callback),
      );
    }

    return const ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text('Unknown answer type'),
    );
  }

  Widget _answerInputNumber(
      InputNumberAnswer answer, OnNumberChanged callback) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: MyInputNumberAnswer(
          answer: answer,
          onNumberChanged: callback,
          debounceTime: 500,
        ),
      ),
    );
  }

  Widget _answerInputText(InputTextAnswer answer, OnTextChanged callback) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Align(
          alignment: Alignment.centerLeft,
          child: MyInputTextAnswer(
            answer: answer,
            onTextChanged: callback,
            debounceTime: 500,
          ),
        ));
  }
}

class _Callbacks {
  void Function(Question) editCallback;
  void Function(Question) removeCallback;

  _Callbacks({required this.editCallback, required this.removeCallback});
}
