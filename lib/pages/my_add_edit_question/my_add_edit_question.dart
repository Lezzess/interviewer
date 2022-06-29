import 'package:flutter/material.dart';
import 'package:interviewer/models/answers/answer.dart';
import 'package:interviewer/models/answers/answer_type.dart';
import 'package:interviewer/models/answers/input_number_answer.dart';
import 'package:interviewer/models/answers/input_text_answer.dart';
import 'package:interviewer/models/answers/select_value_answer.dart';
import 'package:interviewer/models/question.dart';
import 'package:interviewer/pages/my_add_edit_question/widgets/my_dropdown.dart';
import 'package:interviewer/pages/my_add_edit_question/widgets/my_options_answer.dart';
import 'package:interviewer/pages/my_questions/widgets/my_input_number_answer.dart';
import 'package:interviewer/pages/my_questions/widgets/my_input_text_answer.dart';

class MyAddEditQuestion extends StatefulWidget {
  final Question question;
  final Answer? answer;

  const MyAddEditQuestion(
      {super.key, required this.question, required this.answer});

  @override
  State<MyAddEditQuestion> createState() => _MyAddEditQuestionState();
}

class _MyAddEditQuestionState extends State<MyAddEditQuestion> {
  final List<AnswerType> answerTypes = [
    AnswerType.selectValue,
    AnswerType.inputNumber,
    AnswerType.inputText
  ];
  late Question question;
  late Answer? answer;
  late TextEditingController questionController;

  @override
  void initState() {
    question = widget.question;
    answer = widget.answer;
    questionController = TextEditingController(text: question.text);
    super.initState();
  }

  @override
  void dispose() {
    questionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add question'),
        ),
        body: LayoutBuilder(
          builder: (context, constraint) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    _questionInput(),
                    _answerTypeInput(),
                    _answerValuesInput()
                  ],
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.check),
          onPressed: _isValid() ? _onSaveClicked : null,
          backgroundColor: _isValid() ? null : Theme.of(context).disabledColor,
        ));
  }

  Widget _questionInput() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
        child: TextField(
          controller: questionController,
          decoration: InputDecoration(
              hintText: 'Type in a question',
              labelText: 'What to ask?',
              labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primaryContainer),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              alignLabelWithHint: true),
          textCapitalization: TextCapitalization.sentences,
          onChanged: _onQuestionTextChanged,
        ),
      ),
    );
  }

  Widget _answerTypeInput() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
        child: Column(
          children: [
            MyDropdown<AnswerType>(
              values: answerTypes,
              selectedValue: answer?.type,
              onValueChanged: _onAnswerTypeChanged,
              toStringConverter: _mapAnswerTypeToString,
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.stretch,
        ),
      ),
    );
  }

  Widget _answerValuesInput() {
    String cardTitle;
    Widget? answerWidget;

    switch (answer?.type) {
      case AnswerType.selectValue:
        cardTitle = 'Options';
        answerWidget = _answerInputOptions();
        break;
      case AnswerType.inputNumber:
        cardTitle = 'Number';
        answerWidget = _answerInputNumber();
        break;
      case AnswerType.inputText:
        cardTitle = 'Text';
        answerWidget = _answerInputText();
        break;
      default:
        cardTitle = 'Select answer type';
        break;
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
        child: Card(
            child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: InputDecorator(
            decoration: InputDecoration(
                border: InputBorder.none,
                labelText: cardTitle,
                labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.primaryContainer),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                alignLabelWithHint: true),
            child: Padding(
                padding: const EdgeInsets.only(top: 5), child: answerWidget),
          ),
        )),
      ),
    );
  }

  bool _isValid() {
    return question.text != '' && answer != null;
  }

  String _mapAnswerTypeToString(AnswerType type) {
    String stringValue;
    switch (type) {
      case AnswerType.selectValue:
        stringValue = 'Options';
        break;
      case AnswerType.inputNumber:
        stringValue = 'Number';
        break;
      case AnswerType.inputText:
        stringValue = 'Text';
        break;
      default:
        stringValue = '';
        break;
    }

    return stringValue;
  }

  Widget _answerInputOptions() {
    return Align(
        alignment: Alignment.topLeft,
        child: MyOptionsAnswer(
          answer: answer as SelectValueAnswer,
        ));
  }

  Widget _answerInputNumber() {
    return const Align(
      alignment: Alignment.topLeft,
      child: MyInputNumberAnswer(
        enabled: false,
      ),
    );
  }

  Widget _answerInputText() {
    return const Align(
      alignment: Alignment.topLeft,
      child: MyInputTextAnswer(
        enabled: false,
      ),
    );
  }

  void _onQuestionTextChanged(String? newText) {
    setState(() {
      question.text = newText?.trim() ?? '';
    });
  }

  void _onAnswerTypeChanged(AnswerType? answerType) {
    if (answer != null && answer!.type == answerType) {
      return;
    }

    setState(() {
      switch (answerType) {
        case AnswerType.inputNumber:
          answer = InputNumberAnswer.empty();
          break;
        case AnswerType.inputText:
          answer = InputTextAnswer.empty();
          break;
        case AnswerType.selectValue:
          answer = SelectValueAnswer.empty();
          break;
        default:
          answer = null;
          break;
      }
    });
  }

  void _onSaveClicked() {
    final output = AddEditQuestionOutput(question, answer);
    Navigator.pop(context, output);
  }
}

class AddEditQuestionOutput {
  final Question question;
  final Answer? answer;

  AddEditQuestionOutput(this.question, this.answer);
}
