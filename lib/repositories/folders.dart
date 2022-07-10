import 'package:interviewer/db/db.dart';
import 'package:interviewer/models/folder.dart';
import 'package:sqflite/sqflite.dart';

Future<List<Folder>> getAll() async {
  final entries = await Db.instance.query('folders', orderBy: 'order_no');
  final folders = entries.map((e) => Folder.fromDb(e)).toList();

  return folders;
}

Future add(DatabaseExecutor txn, Folder folder) async {
  final entry = folder.toDb();
  await txn.insert('folders', entry);
}

Future clear(DatabaseExecutor txn) async {
  await txn.delete('folders');
}
