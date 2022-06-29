import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:interviewer/models/answers/answer.dart';
import 'package:interviewer/models/answers/input_text_answer.dart';
import 'package:interviewer/models/answers/input_number_answer.dart';
import 'package:interviewer/models/answers/select_value_answer.dart';
import 'package:interviewer/models/question.dart';
import 'package:interviewer/pages/my_questions/widgets/my_input_number_answer.dart';
import 'package:interviewer/pages/my_questions/widgets/my_input_text_answer.dart';
import 'package:interviewer/pages/my_questions/widgets/my_select_value_answer.dart';
import 'package:interviewer/redux/answers/actions.dart';
import 'package:interviewer/redux/answers/selectors.dart';
import 'package:interviewer/redux/app/state.dart';
import 'package:interviewer/redux/questions/selectors.dart';
import 'package:interviewer/styles/app_styles.dart';
import 'package:redux/redux.dart';

typedef OnEdit = void Function(String questionId);
typedef OnRemove = void Function(String questionId);

class MyQuestion extends StatelessWidget {
  final String questionId;
  final OnEdit? onEdit;
  final OnRemove? onRemove;

  const MyQuestion(
      {super.key, required this.questionId, this.onEdit, this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 5),
        child: StoreConnector<AppState, _ViewModel>(
          converter: (store) => _ViewModel.fromStore(store, questionId),
          builder: (context, viewmodel) => Column(
            children: [
              _questionHeader(context, viewmodel.question),
              _answer(context, viewmodel.answer)
            ],
          ),
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
            onPressed: () => onEdit?.call(question.id),
          ),
          IconButton(
            padding: const EdgeInsets.fromLTRB(5, 13, 5, 5),
            constraints: const BoxConstraints(),
            icon: Icon(
              Icons.delete,
              color: Theme.of(context).unselectedWidgetColor,
            ),
            onPressed: () => onRemove?.call(question.id),
          )
        ],
      ),
    );
  }

  Widget _answer(BuildContext context, Answer? answer) {
    if (answer is SelectValueAnswer) {
      return StoreConnector<AppState, OnAnswerSelected>(
        converter: (store) => (answer, value, isSelected) => store
            .dispatch(SetSelectAnswerValueAction(answer.id, value, isSelected)),
        builder: (context, callback) =>
            MySelectValueAnswer(answer: answer, onChanged: callback),
      );
    } else if (answer is InputNumberAnswer) {
      return StoreConnector<AppState, OnNumberChanged>(
        converter: (store) => (answer, newValue) =>
            store.dispatch(SetInputNumberValueAction(answer.id, newValue)),
        builder: (context, callback) => _answerInputNumber(answer, callback),
      );
    } else if (answer is InputTextAnswer) {
      return StoreConnector<AppState, OnTextChanged>(
        converter: (store) => (answer, newText) =>
            store.dispatch(SetInputTextValueAction(answer.id, newText)),
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

class _ViewModel {
  final Question question;
  final Answer? answer;

  _ViewModel({required this.question, required this.answer});

  static _ViewModel fromStore(Store<AppState> store, String questionId) {
    final question = selectQuestion(store.state.questions, questionId);
    final answer = selectAnswer(store.state.answers, question.answerId);

    return _ViewModel(question: question, answer: answer);
  }
}
