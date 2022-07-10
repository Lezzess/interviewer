import 'package:interviewer/db/db.dart';
import 'package:interviewer/models/answers/answer.dart';
import 'package:interviewer/models/answers/input_number_answer.dart';
import 'package:interviewer/models/answers/input_text_answer.dart';
import 'package:interviewer/models/answers/select_value_answer.dart';
import 'package:interviewer/models/question.dart';
import 'package:sqflite/sqflite.dart';
import 'package:collection/collection.dart';

Future<List<Question>> getAll() async {
  final answers = await _getAllAnswers();
  final answersMap = Map.fromIterable(answers, key: (a) => a.questionId);

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

Future update(DatabaseExecutor txn, Question question) async {
  final entry = question.toDb();
  await txn.update(
    'questions',
    entry,
    where: 'id = ?',
    whereArgs: [question.id],
  );
}

Future updateWithAnswers(
  DatabaseExecutor txn,
  Question oldQuestion,
  Question newQuestion,
) async {
  final oldAnswer = oldQuestion.answer;
  if (oldAnswer != null) {
    await _removeAnswer(txn, oldAnswer);
  }

  await update(txn, newQuestion);

  final newAnswer = newQuestion.answer;
  if (newAnswer != null) {
    await _addAnswer(txn, newAnswer);
  }
}

Future remove(DatabaseExecutor txn, Question question) async {
  final answer = question.answer;
  if (answer != null) {
    await _removeAnswer(txn, answer);
  }

  await txn.delete(
    'questions',
    where: 'id = ?',
    whereArgs: [question.id],
  );
}

Future clear(DatabaseExecutor txn) async {
  _clearAnswers(txn);
  await txn.delete('questions');
}

Future<List<Answer>> _getAllAnswers() async {
  final inputTextEntries = await Db.instance.query('answers_input_text');
  final inputTextAnswers =
      inputTextEntries.map((e) => InputTextAnswer.fromDb(e));

  final inputNumberEntries = await Db.instance.query('answers_input_number');
  final inputNumberAnswers =
      inputNumberEntries.map((e) => InputNumberAnswer.fromDb(e));

  final selectEntries = await Db.instance.query('answers_select_value');
  final selectValueEntries =
      await Db.instance.query('answers_select_value_values');
  final groupedSelectValueEntries =
      selectValueEntries.groupListsBy((e) => e['answer_id'] as String);
  final selectAnswers = selectEntries.map((e) {
    final answer = SelectValueAnswer.fromDb(e);
    final valueEntries = groupedSelectValueEntries[answer.id] ?? [];
    final values = valueEntries.map((e) => SelectValue.fromDb(e)).toList();
    answer.values = values;
    return answer;
  });

  final answers = [
    ...inputNumberAnswers,
    ...inputTextAnswers,
    ...selectAnswers
  ];

  return answers;
}

Future _addAnswer(DatabaseExecutor txn, Answer answer) async {
  if (answer is InputNumberAnswer) {
    final entry = answer.toDb();
    await txn.insert('answers_input_number', entry);
  } else if (answer is InputTextAnswer) {
    final entry = answer.toDb();
    await txn.insert('answers_input_text', entry);
  } else if (answer is SelectValueAnswer) {
    final entry = answer.toDb();
    await txn.insert('answers_select_value', entry);

    final valuesEntries = answer.values.map((value) => value.toDb(answer.id));
    for (final valueEntry in valuesEntries) {
      await txn.insert('answers_select_value_values', valueEntry);
    }
  }
}

Future updateAnswer(DatabaseExecutor txn, Answer answer) async {
  await _removeAnswer(txn, answer);
  await _addAnswer(txn, answer);
}

Future _removeAnswer(DatabaseExecutor txn, Answer answer) async {
  if (answer is InputNumberAnswer) {
    await txn.delete(
      'answers_input_number',
      where: 'id = ?',
      whereArgs: [answer.id],
    );
  } else if (answer is InputTextAnswer) {
    await txn.delete(
      'answers_input_text',
      where: 'id = ?',
      whereArgs: [answer.id],
    );
  } else if (answer is SelectValueAnswer) {
    await txn.delete(
      'answers_select_value_values',
      where: 'answer_id = ?',
      whereArgs: [answer.id],
    );
    await txn.delete(
      'answers_select_value',
      where: 'id = ?',
      whereArgs: [answer.id],
    );
  }
}

Future _clearAnswers(DatabaseExecutor txn) async {
  await txn.delete('answers_input_text');
  await txn.delete('answers_input_number');
  await txn.delete('answers_select_value_values');
  await txn.delete('answers_select_value');
}
