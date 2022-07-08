import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:interviewer/models/company.dart';
import 'package:interviewer/pages/my_questions/my_questions_arguments.dart';
import 'package:interviewer/pages/routes.dart';
import 'package:interviewer/redux/app/state.dart';
import 'package:interviewer/redux/companies/actions.dart';
import 'package:interviewer/redux/companies/selectors.dart';
import 'package:redux/redux.dart';

class MyCompanies extends StatefulWidget {
  const MyCompanies({Key? key}) : super(key: key);

  @override
  State<MyCompanies> createState() => _MyCompaniesState();
}

class _MyCompaniesState extends State<MyCompanies> {
  late TextEditingController _companyNameController;

  void onInit(_) {
    _companyNameController = TextEditingController();
  }

  void onDispose(_) {
    _companyNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      onInit: onInit,
      onDispose: onDispose,
      converter: (store) => _ViewModel(
        companies: selectAllCompanies(store.state.companies),
        onAdd: (context) => _onAddClicked(context, store),
        onEdit: (company) => _onEditClicked(context, store, company),
        onRemove: (company) => _onRemoveClicked(store, company),
      ),
      builder: (context, viewModel) => Scaffold(
        appBar: AppBar(title: const Text('Companies')),
        body: ListView.builder(
          itemCount: viewModel.companies.length,
          itemBuilder: (context, index) => _listItem(context, index, viewModel),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => viewModel.onAdd(context),
        ),
      ),
    );
  }

  Widget _listItem(BuildContext context, int index, _ViewModel viewModel) {
    final company = viewModel.companies[index];

    List<Widget> editButtons;
    if (company.isTemplate) {
      // Template cannot be edited
      editButtons = [];
    } else {
      editButtons = [
        // Edit
        IconButton(
          icon: Icon(
            Icons.edit,
            color: Theme.of(context).unselectedWidgetColor,
          ),
          onPressed: () => viewModel.onEdit(company),
        ),
        // Remove
        IconButton(
          icon: Icon(
            Icons.delete,
            color: Theme.of(context).unselectedWidgetColor,
          ),
          onPressed: () => viewModel.onRemove(company),
        )
      ];
    }

    return ListTile(
      title: Text(company.name),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: editButtons,
      ),
      onTap: () => _onCompanyClicked(context, company),
    );
  }

  void _onCompanyClicked(BuildContext context, Company company) async {
    final args = MyQuestionsArguments(company.id);
    await Navigator.pushNamed(context, Routes.questions, arguments: args);
  }

  void _onAddClicked(BuildContext context, Store<AppState> store) async {
    final dialogResult = await _showCompanyDialog(
      text: '',
      saveButton: 'Add',
      cancelButton: 'Cancel',
    );

    final companyName = (dialogResult as String?)?.trim();
    if (companyName != null) {
      store.dispatch(AddCompanyAction(name: companyName));
    }
  }

  void _onEditClicked(
    BuildContext context,
    Store<AppState> store,
    Company company,
  ) async {
    final dialogResult = await _showCompanyDialog(
      text: company.name,
      saveButton: 'Save',
      cancelButton: 'Cancel',
    );

    final companyName = (dialogResult as String?)?.trim();
    if (companyName != null) {
      store.dispatch(UpdateCompanyAction(id: company.id, name: companyName));
    }
  }

  void _onRemoveClicked(Store<AppState> store, Company company) async {
    store.dispatch(RemoveCompanyAction(company.id));
  }

  Future _showCompanyDialog(
      {required String text,
      required String saveButton,
      required String cancelButton}) {
    _companyNameController.text = text;

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Company name'),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Type in company name'),
          controller: _companyNameController,
        ),
        actions: [
          TextButton(
            child: Text(cancelButton),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text(saveButton),
            onPressed: () =>
                Navigator.pop(context, _companyNameController.text),
          ),
        ],
      ),
    );
  }
}

typedef OnAdd = void Function(BuildContext context);
typedef OnEdit = void Function(Company company);
typedef OnRemove = void Function(Company company);

class _ViewModel {
  final List<Company> companies;
  final OnAdd onAdd;
  final OnEdit onEdit;
  final OnRemove onRemove;

  _ViewModel({
    required this.companies,
    required this.onAdd,
    required this.onEdit,
    required this.onRemove,
  });

  @override
  bool operator ==(Object other) =>
      other is _ViewModel &&
      other.runtimeType == runtimeType &&
      listEquals(other.companies, companies);

  @override
  int get hashCode => hashList(companies);
}
