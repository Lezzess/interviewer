import 'package:flutter/material.dart';
import 'package:interviewer/models/folder.dart';
import 'package:interviewer/models/question.dart';
import 'package:interviewer/pages/my_add_edit_question/my_add_edit_question_arguments.dart';
import 'package:interviewer/pages/my_questions/widgets/my_question.dart';
import 'package:interviewer/pages/routes.dart';
import 'package:interviewer/states/companies_state.dart';
import 'package:interviewer/states/folders_state.dart';
import 'package:interviewer/states/questions_state.dart';
import 'package:provider/provider.dart';

class MyQuestions extends StatelessWidget {
  final String companyId;

  const MyQuestions({super.key, required this.companyId});

  @override
  Widget build(BuildContext context) {
    final companiesState = context.watch<CompaniesState>();
    final company = companiesState.companies.firstWhere(
      (c) => c.id == companyId,
    );

    final questionsState = context.watch<QuestionsState>();
    final questions = questionsState.getQuestions(companyId);

    final foldersState = context.watch<FoldersState>();
    return DefaultTabController(
      length: foldersState.folders.length + 1, // One more for "Add" tab
      child: Scaffold(
        appBar: AppBar(
          title: Text(company.name),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                isScrollable: true,
                labelColor: Theme.of(context).primaryColor,
                tabs: _tabs(foldersState),
              ),
            ),
          ),
          actions: [
            if (!company.isTemplate)
              IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: questions.isEmpty
                      ? () => _onFillFromTemplateClicked(context)
                      : null),
            IconButton(
              icon: const Icon(Icons.folder),
              onPressed: () => _onFoldersClicked(context),
            )
          ],
        ),
        body: TabBarView(
          children: [
            _tabView(context, questions),
            for (final folder in foldersState.folders)
              _tabView(context, selectFolderQuestions(questions, folder))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => _onAddClicked(context),
        ),
      ),
    );
  }

  List<Widget> _tabs(FoldersState state) {
    return [
      const Tab(text: 'All'),
      for (var folder in state.folders) Tab(text: folder.name)
    ];
  }

  Widget _tabView(BuildContext context, List<Question> questions) {
    return ListView.builder(
      // One more item for empty box at the bottom
      itemCount: questions.length + 1,
      itemBuilder: (context, index) => _listItem(questions, index, context),
    );
  }

  Widget _listItem(List<Question> questions, int index, BuildContext context) {
    if (index >= questions.length) {
      return Container(height: 80);
    }

    return MyQuestion(
      question: questions[index],
      onEdit: (question) => _onEditClicked(context, question),
      onRemove: (question) => _onRemoveClicked(context, question),
    );
  }

  List<Question> selectFolderQuestions(
    List<Question> allQuestions,
    Folder folder,
  ) {
    return allQuestions
        .where((question) => question.folderId == folder.id)
        .toList();
  }

  void _onFillFromTemplateClicked(BuildContext context) {
    final questionsState = context.read<QuestionsState>();
    final companiesState = context.read<CompaniesState>();
    questionsState.fillFromTemplate(companyId, companiesState);
  }

  void _onFoldersClicked(BuildContext context) async {
    await Navigator.pushNamed(context, Routes.folders);
  }

  void _onAddClicked(BuildContext context) async {
    final question = Question.empty(companyId);
    final args = MyAddEditQuestionArguments(question);
    final result = await Navigator.pushNamed(
      context,
      Routes.addQuestion,
      arguments: args,
    );

    if (result != null) {
      final state = context.read<QuestionsState>();
      state.add(question);
    }
  }

  void _onEditClicked(
    BuildContext context,
    Question question,
  ) async {
    final copy = question.clone();
    final args = MyAddEditQuestionArguments(copy);
    final result = await Navigator.pushNamed(context, Routes.editQuestion,
        arguments: args);

    if (result != null) {
      final updatedQuestion = result as Question;
      final state = context.read<QuestionsState>();
      state.update(question, updatedQuestion);
    }
  }

  void _onRemoveClicked(
    BuildContext context,
    Question question,
  ) {
    final state = context.read<QuestionsState>();
    state.remove(question);
  }
}
