import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:interviewer/models/folder.dart';
import 'package:interviewer/redux/app/state.dart';
import 'package:interviewer/redux/folders/actions.dart';
import 'package:interviewer/redux/folders/selectors.dart';
import 'package:redux/redux.dart';

class MyFolders extends StatefulWidget {
  const MyFolders({Key? key}) : super(key: key);

  @override
  State<MyFolders> createState() => _MyFoldersState();
}

class _MyFoldersState extends State<MyFolders> {
  late TextEditingController _folderNameController;

  void onInit(_) {
    _folderNameController = TextEditingController();
  }

  void onDispose(_) {
    _folderNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      onInit: onInit,
      onDispose: onDispose,
      converter: (store) => _ViewModel(
          folders: selectAllFolders(store.state.folders),
          onAdd: (context) => _onAddClicked(context, store),
          onEdit: (folder) => _onEditClicked(context, store, folder),
          onRemove: (folder) => _onRemoveClicked(store, folder),
          onReorder: (oldIndex, newIndex) =>
              _onReorder(store, oldIndex, newIndex)),
      builder: (context, viewModel) => Scaffold(
        appBar: AppBar(title: const Text('Folders')),
        body: ReorderableListView.builder(
          itemCount: viewModel.folders.length,
          itemBuilder: (context, index) => _listItem(index, viewModel),
          onReorder: viewModel.onReorder,
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => viewModel.onAdd(context),
        ),
      ),
    );
  }

  Widget _listItem(int index, _ViewModel viewModel) {
    final folder = viewModel.folders[index];
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
            onPressed: () => viewModel.onEdit(folder),
          ),
          // Remove
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Theme.of(context).unselectedWidgetColor,
            ),
            onPressed: () => viewModel.onRemove(folder),
          )
        ],
      ),
    );
  }

  void _onAddClicked(BuildContext context, Store<AppState> store) async {
    final dialogResult = await _showFolderDialog(
      text: '',
      saveButton: 'Add',
      cancelButton: 'Cancel',
    );

    final folderName = (dialogResult as String?)?.trim();
    if (folderName != null) {
      final order = store.state.folders.all.length;
      store.dispatch(AddFolderAction(name: folderName, order: order));
    }
  }

  void _onEditClicked(
    BuildContext context,
    Store<AppState> store,
    Folder folder,
  ) async {
    final dialogResult = await _showFolderDialog(
      text: folder.name,
      saveButton: 'Save',
      cancelButton: 'Cancel',
    );

    final folderName = (dialogResult as String?)?.trim();
    if (folderName != null) {
      store.dispatch(UpdateFolderAction(id: folder.id, name: folderName));
    }
  }

  void _onRemoveClicked(Store<AppState> store, Folder folder) async {
    store.dispatch(RemoveFolderAction(folder.id));
  }

  void _onReorder(Store<AppState> store, int oldIndex, int newIndex) {
    store.dispatch(ReorderFolderAction(oldIndex: oldIndex, newIndex: newIndex));
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

typedef OnAdd = void Function(BuildContext context);
typedef OnEdit = void Function(Folder folder);
typedef OnRemove = void Function(Folder folder);
typedef OnReorder = void Function(int oldIndex, int newIndex);

class _ViewModel {
  final List<Folder> folders;
  final OnAdd onAdd;
  final OnEdit onEdit;
  final OnRemove onRemove;
  final OnReorder onReorder;

  _ViewModel(
      {required this.folders,
      required this.onAdd,
      required this.onEdit,
      required this.onRemove,
      required this.onReorder});

  @override
  bool operator ==(Object other) =>
      other is _ViewModel &&
      other.runtimeType == runtimeType &&
      listEquals(other.folders, folders);

  @override
  int get hashCode => hashList(folders);
}
