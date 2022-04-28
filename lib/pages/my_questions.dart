import 'package:flutter/material.dart';
import 'package:interviewer/models/question.dart';
import 'package:interviewer/states/app_state.dart';
import 'package:provider/provider.dart';

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
          itemBuilder: (context, index) => _MyQuestion(
              key: ValueKey(questions[index].text),
              question: questions[index])),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}

class _MyQuestion extends StatelessWidget {
  final Question question;

  const _MyQuestion({Key? key, required this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(question.text),
    );
  }
}
