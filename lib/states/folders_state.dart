import 'package:flutter/material.dart';
import 'package:interviewer/models/folder.dart';
import 'package:interviewer/states/questions_state.dart';

class FoldersState with ChangeNotifier {
  final List<Folder> folders;

  FoldersState(this.folders);

  void add(String name) {
    final order = folders.length;
    final folder = Folder.withName(name, order);
    folders.add(folder);
    notifyListeners();
  }

  void update(Folder folder, String name) {
    folder.name = name;
    notifyListeners();
  }

  void remove(Folder folder, QuestionsState questionsState) {
    folders.remove(folder);
    _alignFoldersOrder();
    questionsState.removeQuestionsFolder(folder);
    notifyListeners();
  }

  void reorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final folderToReplace = folders.removeAt(oldIndex);
    folders.insert(newIndex, folderToReplace);

    _alignFoldersOrder();

    notifyListeners();
  }

  void _alignFoldersOrder() {
    for (var i = 0; i < folders.length; i++) {
      final folder = folders[i];
      if (folder.order != i) {
        folder.order = i;
      }
    }
  }
}
