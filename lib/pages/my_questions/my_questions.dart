import 'package:flutter/material.dart';
import 'package:interviewer/models/answers/value_answer.dart';
import 'package:interviewer/app/app_state.dart';
import 'package:interviewer/pages/my_questions/question_state.dart';
import 'package:provider/provider.dart';
import 'package:interviewer/app/app_styles.dart';
import 'package:collection/collection.dart';

class MyQuestions extends StatelessWidget {
  const MyQuestions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final questions = context.select((AppState state) => state.questions);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Questions'),
      ),
      body: ListView.builder(
          itemCount: questions.length,
          itemBuilder: (context, index) => ChangeNotifierProvider(
                create: (context) => QuestionState(question: questions[index]),
                child: const _MyQuestion(),
              )),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}

class _MyQuestion extends StatelessWidget {
  const _MyQuestion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final question = context.watch<QuestionState>().question;
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                question.text,
                style: Theme.of(context).textTheme.questionText,
              ),
            ),
            _MySelectValueAnswer(
              answer: question.answer,
              onChanged: (answer, value, isSelected) =>
                  _setValueIsSelected(context, answer, value, isSelected),
            )
          ],
        ),
      ),
    );
  }

  void _setValueIsSelected(BuildContext context, SelectValueAnswer answer,
      SelectValue value, bool isSelected) {
    final state = context.read<QuestionState>();
    state.setAnswerSelected(answer, value, isSelected);
  }
}

class _MySelectValueAnswer extends StatelessWidget {
  final SelectValueAnswer answer;
  final Function(SelectValueAnswer answer, SelectValue value, bool isSelected)
      onChanged;

  const _MySelectValueAnswer(
      {Key? key, required this.answer, required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: answer.values.length,
      itemBuilder: (context, index) =>
          answer.isMultipleSelect ? _checkbox(index) : _radio(index),
    );
  }

  Widget _checkbox(int index) {
    return CheckboxListTile(
      title: Text(answer.values[index].value),
      onChanged: (isSelected) =>
          onChanged(answer, answer.values[index], isSelected ?? false),
      value: answer.values[index].isSelected,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  Widget _radio(int index) {
    final selectedValue =
        answer.values.firstWhereOrNull((element) => element.isSelected);
    return RadioListTile<SelectValue?>(
        toggleable: true,
        title: Text(answer.values[index].value),
        value: answer.values[index],
        groupValue: selectedValue,
        onChanged: (value) => onChanged(
            answer, answer.values[index], value == answer.values[index]));
  }
}
