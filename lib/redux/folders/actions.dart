import 'package:interviewer/extensions/immutable_list.dart';
import 'package:interviewer/extensions/immutable_map.dart';
import 'package:interviewer/models/folder.dart';
import 'package:interviewer/redux/app/actions.dart';
import 'package:interviewer/redux/folders/selectors.dart';
import 'package:interviewer/redux/folders/state.dart';

class AddFolderAction extends AppAction<FoldersState> {
  final String name;
  final int order;

  AddFolderAction({required this.name, required this.order});

  @override
  FoldersState handle(FoldersState state) {
    final newFolder = Folder.withName(name, order);

    final newById = state.byId.iadd(newFolder.id, newFolder);
    final newAll = state.all.iadd(newFolder.id);

    final newState = state.copyWith(byId: newById, all: newAll);
    return newState;
  }
}

class UpdateFolderAction extends AppAction<FoldersState> {
  final String id;
  final String name;

  UpdateFolderAction({required this.id, required this.name});

  @override
  FoldersState handle(FoldersState state) {
    final folder = selectFolder(state, id)!;
    final newFolder = folder.copyWith(id: id, name: name);

    final newById = state.byId.ireplace(id, newFolder);
    final newState = state.copyWith(byId: newById);

    return newState;
  }
}

class RemoveFolderAction extends AppAction<FoldersState> {
  final String id;

  RemoveFolderAction(this.id);

  @override
  FoldersState handle(FoldersState state) {
    var newById = state.byId.iremove(id);
    final newAll = state.all.iremove(id);

    for (var i = 0; i < newAll.length; i++) {
      final id = newAll[i];
      final folder = newById[id]!;

      if (folder.order != i) {
        final newFolder = folder.copyWith(order: i);
        newById = newById.ireplace(id, newFolder);
      }
    }

    final newState = state.copyWith(byId: newById, all: newAll);
    return newState;
  }
}

class ReorderFolderAction extends AppAction<FoldersState> {
  int oldIndex;
  int newIndex;

  ReorderFolderAction({required this.oldIndex, required this.newIndex});

  @override
  FoldersState handle(FoldersState state) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final folderList = selectAllFolders(state);
    final folderToReplace = folderList.removeAt(oldIndex);
    folderList.insert(newIndex, folderToReplace);

    var newById = state.byId;
    for (var i = 0; i < folderList.length; i++) {
      final folder = folderList[i];
      if (folder.order == i) {
        continue;
      }

      final newFolder = folder.copyWith(order: i);
      newById = newById.ireplace(folder.id, newFolder);
      folderList[i] = newFolder;
    }
    final newAll = folderList.map((folder) => folder.id).toList();

    final newState = state.copyWith(byId: newById, all: newAll);
    return newState;
  }
}
