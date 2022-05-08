import 'package:flutter/material.dart';
import 'package:interviewer/models/answers/answer.dart';
import 'package:interviewer/models/answers/input_text_answer.dart';
import 'package:interviewer/pages/my_questions/widgets/my_input_answers.dart';
import 'package:interviewer/models/answers/input_number_answer.dart';
import 'package:interviewer/models/answers/select_value_answer.dart';
import 'package:interviewer/app/app_state.dart';
import 'package:interviewer/models/question.dart';
import 'package:interviewer/pages/my_questions/question_state.dart';
import 'package:interviewer/pages/my_questions/widgets/my_select_answers.dart';
import 'package:provider/provider.dart';
import 'package:interviewer/app/app_styles.dart';

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
          shrinkWrap: true,
          // One more item for empty box in the bottom
          itemCount: questions.length + 1,
          itemBuilder: (context, index) =>
              _listItem(questions, index, context)),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }

  Widget _listItem(List<Question> questions, int index, BuildContext context) {
    return index < questions.length
        ? ChangeNotifierProvider(
            create: (context) => QuestionState(question: questions[index]),
            child: const _MyQuestion(),
          )
        : Container(
            height: 80,
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
            _answer(context, question.answer)
          ],
        ),
      ),
    );
  }

  Widget _answer(BuildContext context, Answer answer) {
    if (answer is SelectValueAnswer) {
      return MySelectValueAnswer(
        answer: answer,
        onChanged: (answer, value, isSelected) =>
            _setValueIsSelected(context, answer, value, isSelected),
      );
    } else if (answer is InputNumberAnswer) {
      return MyInputNumberAnswer(answer: answer);
    } else if (answer is InputTextAnswer) {
      return MyInputTextAnswer(answer: answer);
    }

    return const ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text('Unknown answer type'),
    );
  }

  void _setValueIsSelected(BuildContext context, SelectValueAnswer answer,
      SelectValue value, bool isSelected) {
    final state = context.read<QuestionState>();
    state.setAnswerSelected(answer, value, isSelected);
  }
}
