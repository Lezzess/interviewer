import 'package:flutter/material.dart';
import 'package:interviewer/models/folder.dart';
import 'package:interviewer/states/folders_state.dart';
import 'package:interviewer/states/questions_state.dart';
import 'package:provider/provider.dart';

class MyFolders extends StatefulWidget {
  const MyFolders({Key? key}) : super(key: key);

  @override
  State<MyFolders> createState() => _MyFoldersState();
}

class _MyFoldersState extends State<MyFolders> {
  late TextEditingController _folderNameController;

  @override
  void initState() {
    _folderNameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _folderNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<FoldersState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Folders')),
      body: ReorderableListView.builder(
        itemCount: state.folders.length,
        itemBuilder: (context, index) => _listItem(index, state),
        onReorder: (oldIndex, newIndex) => _onReorder(
          context,
          oldIndex,
          newIndex,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _onAddClicked(context),
      ),
    );
  }

  Widget _listItem(int index, FoldersState state) {
    final folder = state.folders[index];
    return ListTile(
      key: ValueKey(index),
      title: Text(folder.name),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Edit
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Theme.of(context).unselectedWidgetColor,
            ),
            onPressed: () => _onEditClicked(context, folder),
          ),
          // Remove
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Theme.of(context).unselectedWidgetColor,
            ),
            onPressed: () => _onRemoveClicked(context, folder),
          )
        ],
      ),
    );
  }

  void _onAddClicked(BuildContext context) async {
    final dialogResult = await _showFolderDialog(
      text: '',
      saveButton: 'Add',
      cancelButton: 'Cancel',
    );

    final folderName = (dialogResult as String?)?.trim();
    if (folderName != null) {
      final state = context.read<FoldersState>();
      state.add(folderName);
    }
  }

  void _onEditClicked(
    BuildContext context,
    Folder folder,
  ) async {
    final dialogResult = await _showFolderDialog(
      text: folder.name,
      saveButton: 'Save',
      cancelButton: 'Cancel',
    );

    final folderName = (dialogResult as String?)?.trim();
    if (folderName != null) {
      final state = context.read<FoldersState>();
      state.update(folder, folderName);
    }
  }

  void _onRemoveClicked(BuildContext context, Folder folder) async {
    final foldersState = context.read<FoldersState>();
    final questionsState = context.read<QuestionsState>();
    foldersState.remove(folder, questionsState);
  }

  void _onReorder(BuildContext context, int oldIndex, int newIndex) {
    final state = context.read<FoldersState>();
    state.reorder(oldIndex, newIndex);
  }

  Future _showFolderDialog(
      {required String text,
      required String saveButton,
      required String cancelButton}) {
    _folderNameController.text = text;

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Folder name'),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Type in folder name'),
          controller: _folderNameController,
        ),
        actions: [
          TextButton(
            child: Text(cancelButton),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text(saveButton),
            onPressed: () => Navigator.pop(context, _folderNameController.text),
          ),
        ],
      ),
    );
  }
}
