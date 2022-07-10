import 'package:flutter/material.dart';
import 'package:interviewer/models/company.dart';
import 'package:interviewer/pages/my_questions/my_questions_arguments.dart';
import 'package:interviewer/pages/routes.dart';
import 'package:interviewer/states/companies_state.dart';
import 'package:interviewer/states/questions_state.dart';
import 'package:provider/provider.dart';

class MyCompanies extends StatefulWidget {
  const MyCompanies({Key? key}) : super(key: key);

  @override
  State<MyCompanies> createState() => _MyCompaniesState();
}

class _MyCompaniesState extends State<MyCompanies> {
  late TextEditingController _companyNameController;

  @override
  void initState() {
    _companyNameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CompaniesState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Companies')),
      body: ListView.builder(
        itemCount: state.companies.length,
        itemBuilder: (context, index) => _listItem(context, state, index),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _onAddClicked(context),
      ),
    );
  }

  Widget _listItem(BuildContext context, CompaniesState state, int index) {
    final company = state.companies[index];

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
          onPressed: () => _onEditClicked(context, company),
        ),
        // Remove
        IconButton(
          icon: Icon(
            Icons.delete,
            color: Theme.of(context).unselectedWidgetColor,
          ),
          onPressed: () => _onRemoveClicked(context, company),
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

  void _onAddClicked(BuildContext context) async {
    final dialogResult = await _showCompanyDialog(
      text: '',
      saveButton: 'Add',
      cancelButton: 'Cancel',
    );

    final companyName = (dialogResult as String?)?.trim();
    if (companyName != null) {
      final state = context.read<CompaniesState>();
      state.add(companyName);
    }
  }

  void _onEditClicked(
    BuildContext context,
    Company company,
  ) async {
    final dialogResult = await _showCompanyDialog(
      text: company.name,
      saveButton: 'Save',
      cancelButton: 'Cancel',
    );

    final companyName = (dialogResult as String?)?.trim();
    if (companyName != null) {
      final state = context.read<CompaniesState>();
      state.update(company, companyName);
    }
  }

  void _onRemoveClicked(BuildContext context, Company company) async {
    final companiesState = context.read<CompaniesState>();
    final questionsState = context.read<QuestionsState>();
    companiesState.remove(company, questionsState);
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
