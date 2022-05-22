import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:interviewer/models/answers/input_text_answer.dart';
import 'package:interviewer/models/answers/input_number_answer.dart';
import 'package:interviewer/models/answers/select_value_answer.dart';
import 'package:interviewer/models/question.dart';
import 'package:interviewer/pages/my_questions/widgets/my_input_number_answer.dart';
import 'package:interviewer/pages/my_questions/widgets/my_input_text_answer.dart';
import 'package:interviewer/pages/my_questions/widgets/my_select_value_answer.dart';
import 'package:interviewer/app/app_styles.dart';
import 'package:interviewer/redux/app_state.dart';
import 'package:interviewer/redux/questions/answers/set_input_number_value.dart';
import 'package:interviewer/redux/questions/answers/set_input_text_value.dart';
import 'package:interviewer/redux/questions/answers/set_select_answer_value.dart';

class MyQuestions extends StatelessWidget {
  const MyQuestions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Questions'),
      ),
      body: StoreConnector<AppState, List<Question>>(
        converter: (store) => store.state.questions,
        builder: (context, questions) => ListView.builder(
            shrinkWrap: true,
            // One more item for empty box in the bottom
            itemCount: questions.length + 1,
            itemBuilder: (context, index) =>
                _listItem(questions, index, context)),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }

  Widget _listItem(List<Question> questions, int index, BuildContext context) {
    return index < questions.length
        ? _MyQuestion(
            question: questions[index],
          )
        : Container(
            height: 80,
          );
  }
}

class _MyQuestion extends StatelessWidget {
  final Question question;

  const _MyQuestion({Key? key, required this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: Theme.of(context).colorScheme.primary))),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  question.text,
                  style: Theme.of(context).textTheme.questionText,
                ),
              ),
            ),
            _answer(context, question)
          ],
        ),
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
        builder: (context, callback) => MyInputNumberAnswer(
          answer: answer,
          onNumberChanged: callback,
          debounceTime: 500,
        ),
      );
    } else if (answer is InputTextAnswer) {
      return StoreConnector<AppState, OnTextChanged>(
        converter: (store) => (answer, newText) =>
            store.dispatch(SetInputTextValueAction(question, answer, newText)),
        builder: (context, callback) => MyInputTextAnswer(
          answer: answer,
          onTextChanged: callback,
          debounceTime: 500,
        ),
      );
    }

    return const ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text('Unknown answer type'),
    );
  }
}
