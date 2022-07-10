import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const _dbName = 'interviewer.db';

Future initializeDatabase() async {
  final folderPath = await getDatabasesPath();
  await deleteDatabase(folderPath);

  final filePath = join(folderPath, _dbName);
  final db = await openDatabase(
    filePath,
    version: 1,
    onCreate: (db, _) => _runInitialScript(db),
  );
  Db.instance = db;
}

Future _runInitialScript(Database db) async {
  final sql = await rootBundle.loadString('assets/scripts/initial.sql');
  final queries =
      sql.split(';').map((s) => s.trim()).where((s) => s.isNotEmpty);
  for (final query in queries) {
    await db.execute(query);
  }
}

class Db {
  static late Database instance;

  static Future<T> transaction<T>(
    Future<T> Function(Transaction txn) action,
  ) async {
    return instance.transaction<T>(action);
  }
}
