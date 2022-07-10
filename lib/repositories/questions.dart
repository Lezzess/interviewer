import 'package:interviewer/db/db.dart';
import 'package:interviewer/models/answers/answer.dart';
import 'package:interviewer/models/answers/answer_type.dart';
import 'package:interviewer/models/answers/input_number_answer.dart';
import 'package:interviewer/models/answers/input_text_answer.dart';
import 'package:interviewer/models/answers/select_value_answer.dart';
import 'package:interviewer/models/question.dart';
import 'package:sqflite/sqflite.dart';
import 'package:collection/collection.dart';

Future<List<Question>> getAll() async {
  final allAnswers = await _getAllAnswers();
  final answersMap = Map.fromIterable(allAnswers, key: (a) => a.questionId);

  final entries = await Db.instance.query('questions');
  final questions = entries.map((e) {
    final question = Question.fromDb(e);
    question.answer = answersMap[question.id];
    return question;
  }).toList();

  return questions;
}

Future add(DatabaseExecutor txn, Question question) async {
  final entry = question.toDb();
  await txn.insert('questions', entry);

  if (question.answer != null) {
    _addAnswer(txn, question.answer!);
  }
}

Future clear(DatabaseExecutor txn) async {
  _clearAnswers(txn);
  await txn.delete('questions');
}

Future<List<Answer>> _getAllAnswers() async {
  final entries = await Db.instance.query('answers');

  final selectValueEntries = await Db.instance.query('answers_selected_values');
  final groupedValueEntries =
      selectValueEntries.groupListsBy((entry) => entry['answer_id'] as String);

  final answers = entries.map((entry) {
    final typeString = entry['type'] as String;
    final type = AnswerType.values.byName(typeString);

    switch (type) {
      case AnswerType.inputNumber:
        return InputNumberAnswer.fromDb(entry);
      case AnswerType.inputText:
        return InputTextAnswer.fromDb(entry);
      case AnswerType.selectValue:
        final answer = SelectValueAnswer.fromDb(entry);

        final answerValueEntries = groupedValueEntries[answer.id] ?? [];
        final selectValues =
            answerValueEntries.map((e) => SelectValue.fromDb(e)).toList();
        answer.values = selectValues;

        return answer;
    }
  }).toList();

  return answers;
}

Future _addAnswer(DatabaseExecutor txn, Answer answer) async {
  if (answer is InputNumberAnswer) {
    final entry = answer.toDb();
    await txn.insert('answers', entry);
  } else if (answer is InputTextAnswer) {
    final entry = answer.toDb();
    await txn.insert('answers', entry);
  } else if (answer is SelectValueAnswer) {
    final entry = answer.toDb();
    await txn.insert('answers', entry);

    final valuesEntries =
        answer.values.map((value) => value.toDb(answer.id)).toList();
    for (final valueEntry in valuesEntries) {
      await txn.insert('answers_selected_values', valueEntry);
    }
  }
}

Future _clearAnswers(DatabaseExecutor txn) async {
  await txn.delete('answers_selected_values');
  await txn.delete('answers');
}
