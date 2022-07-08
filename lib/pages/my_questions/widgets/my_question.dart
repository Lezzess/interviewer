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
import 'package:interviewer/redux/questions/actions.dart';
import 'package:interviewer/redux/questions/selectors.dart';
import 'package:interviewer/styles/app_styles.dart';
import 'package:redux/redux.dart';
import 'package:rxdart/rxdart.dart';

typedef OnEdit = void Function(String questionId);
typedef OnRemove = void Function(String questionId);

class MyQuestion extends StatefulWidget {
  final String questionId;
  final OnEdit? onEdit;
  final OnRemove? onRemove;

  const MyQuestion({
    super.key,
    required this.questionId,
    this.onEdit,
    this.onRemove,
  });

  @override
  State<MyQuestion> createState() => _MyQuestionState();
}

class _MyQuestionState extends State<MyQuestion> {
  bool isNoteVisible = false;
  late BehaviorSubject<String> _subject;
  late TextEditingController _textController;

  void _onInit(Store<AppState> store) {
    final question = selectQuestion(store.state.questions, widget.questionId);

    _textController = TextEditingController(text: question.note);
    _subject = BehaviorSubject<String>.seeded(question.note ?? '');
    _subject.stream
        .skip(1)
        .debounceTime(const Duration(milliseconds: 500))
        .distinct()
        .listen((value) =>
            store.dispatch(AddQuestionNoteAction(question.id, value)));
  }

  void _onDispose(_) {
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 5),
        child: StoreConnector<AppState, _ViewModel>(
          onInit: _onInit,
          onDispose: _onDispose,
          converter: (store) => _ViewModel.fromStore(
            store,
            widget.questionId,
            onNoteChanged: (noteText) => _subject.add(noteText),
          ),
          builder: (context, viewmodel) => Column(
            children: [
              _questionHeader(context, viewmodel.question),
              Stack(
                children: [
                  _answer(context, viewmodel.answer),
                  if (isNoteVisible) _note(context, viewmodel.onNoteChanged)
                ],
              )
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
            icon: Icon(Icons.note_alt,
                color: Theme.of(context).unselectedWidgetColor),
            onPressed: _showNoteField,
          ),
          IconButton(
            padding: const EdgeInsets.fromLTRB(5, 13, 5, 5),
            constraints: const BoxConstraints(),
            icon: Icon(
              Icons.edit,
              color: Theme.of(context).unselectedWidgetColor,
            ),
            onPressed: () => widget.onEdit?.call(question.id),
          ),
          IconButton(
            padding: const EdgeInsets.fromLTRB(5, 13, 5, 5),
            constraints: const BoxConstraints(),
            icon: Icon(
              Icons.delete,
              color: Theme.of(context).unselectedWidgetColor,
            ),
            onPressed: () => widget.onRemove?.call(question.id),
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

  Widget _note(BuildContext context, OnNoteChanged onNoteChanged) {
    return Positioned.fill(
      child: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.all(Radius.circular(10.0))),
          child: TextField(
            controller: _textController,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(10.0),
            ),
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            cursorColor: Theme.of(context).colorScheme.onPrimary,
            minLines: null,
            maxLines: null,
            expands: true,
            autofocus: true,
            onChanged: onNoteChanged,
          ),
        ),
      ),
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

  void _showNoteField() {
    setState(() {
      isNoteVisible = !isNoteVisible;
    });
  }
}

typedef OnNoteChanged = void Function(String noteText);

class _ViewModel {
  final Question question;
  final Answer? answer;
  final OnNoteChanged onNoteChanged;

  _ViewModel({
    required this.question,
    required this.answer,
    required this.onNoteChanged,
  });

  static _ViewModel fromStore(
    Store<AppState> store,
    String questionId, {
    required OnNoteChanged onNoteChanged,
  }) {
    final question = selectQuestion(store.state.questions, questionId);
    final answer = selectAnswer(store.state.answers, question.answerId);

    return _ViewModel(
      question: question,
      answer: answer,
      onNoteChanged: onNoteChanged,
    );
  }
}
