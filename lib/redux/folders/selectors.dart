import 'package:interviewer/models/folder.dart';
import 'package:interviewer/redux/folders/state.dart';

List<Folder> selectAllFolders(FoldersState state) {
  final ids = state.all;
  final questions = ids.map((id) => state.byId[id]!).toList();

  return questions;
}

Folder? selectFolder(FoldersState state, String? id) {
  return id == null ? null : state.byId[id]!;
}
