import 'package:interviewer/db/db.dart';
import 'package:interviewer/models/company.dart';
import 'package:sqflite/sqflite.dart';

Future<List<Company>> getAll() async {
  final entries = await Db.instance.query('companies');
  final companies = entries.map((e) => Company.fromDb(e)).toList();

  return companies;
}

Future add(DatabaseExecutor txn, Company company) async {
  final entry = company.toDb();
  await txn.insert('companies', entry);
}

Future clear(DatabaseExecutor txn) async {
  await txn.delete('companies');
}
