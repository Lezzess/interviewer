import 'package:flutter/services.dart';
import 'package:interviewer/models/company.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:interviewer/repositories/companies.dart' as companies;

const _dbName = 'interviewer.db';

Future initializeDatabase() async {
  final folderPath = await getDatabasesPath();
  final filePath = join(folderPath, _dbName);
  final db = await openDatabase(filePath, version: 1, onCreate: _onCreate);
  Db.instance = db;
}

Future _onCreate(Database db, int version) async {
  await _runInitialScript(db);
  await _addTemplateCompany(db);
}

Future _runInitialScript(Database db) async {
  final sql = await rootBundle.loadString('assets/scripts/initial.sql');
  final queries =
      sql.split(';').map((s) => s.trim()).where((s) => s.isNotEmpty);
  for (final query in queries) {
    await db.execute(query);
  }
}

Future _addTemplateCompany(Database db) async {
  final company = Company.withName('Template', isTemplate: true);
  await companies.add(db, company);
}

class Db {
  static late Database instance;

  static Future<T> transaction<T>(
    Future<T> Function(Transaction txn) action,
  ) async {
    return instance.transaction<T>(action);
  }
}
