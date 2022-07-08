import 'package:interviewer/models/folder.dart';

class FoldersState {
  final Map<String, Folder> byId;
  final List<String> all;

  FoldersState({required this.byId, required this.all});

  FoldersState copyWith({Map<String, Folder>? byId, List<String>? all}) {
    return FoldersState(byId: byId ?? this.byId, all: all ?? this.all);
  }
}
