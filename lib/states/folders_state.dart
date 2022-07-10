import 'package:flutter/material.dart';
import 'package:interviewer/db/db.dart';
import 'package:interviewer/models/folder.dart';
import 'package:interviewer/states/questions_state.dart';
import 'package:interviewer/repositories/folders.dart' as rfolders;
import 'package:sqflite/sqflite.dart';

class FoldersState with ChangeNotifier {
  final List<Folder> folders;

  FoldersState(this.folders);

  void add(String name) async {
    await Db.transaction((txn) async {
      final order = folders.length;
      final folder = Folder.withName(name, order);
      folders.add(folder);

      notifyListeners();

      await rfolders.add(txn, folder);
    });
  }

  void update(Folder folder, String name) async {
    await Db.transaction((txn) async {
      folder.name = name;
      notifyListeners();
      await rfolders.update(txn, folder);
    });
  }

  void remove(Folder folder, QuestionsState questionsState) async {
    await Db.transaction((txn) async {
      folders.remove(folder);
      await _alignFoldersOrder(txn);

      questionsState.removeQuestionsFolder(txn, folder);
      notifyListeners();

      await rfolders.remove(txn, folder);
    });
  }

  void reorder(int oldIndex, int newIndex) async {
    await Db.transaction((txn) async {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }

      final folderToReplace = folders.removeAt(oldIndex);
      folders.insert(newIndex, folderToReplace);
      folderToReplace.order = newIndex;

      notifyListeners();

      await rfolders.update(txn, folderToReplace);
      _alignFoldersOrder(txn);
    });
  }

  Future _alignFoldersOrder(Transaction txn) async {
    for (var i = 0; i < folders.length; i++) {
      final folder = folders[i];
      if (folder.order != i) {
        folder.order = i;
        await rfolders.update(txn, folder);
      }
    }
  }
}
