import 'package:flutter/material.dart';
import 'package:interviewer/models/folder.dart';
import 'package:interviewer/models/question.dart';
import 'package:interviewer/pages/my_add_edit_question/my_add_edit_question_arguments.dart';
import 'package:interviewer/pages/my_questions/widgets/my_question.dart';
import 'package:interviewer/pages/my_questions/widgets/my_sticky_app_bar.dart';
import 'package:interviewer/pages/routes.dart';
import 'package:interviewer/states/companies_state.dart';
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
    final questions = questionsState.questions
        .where(
          (q) => q.companyId == companyId,
        )
        .toList();

    return Scaffold(
      body: MyStickyAppBar(
          title: Text(company.name),
          isFillFromTemplateAvailable: questions.isEmpty,
          onFillFromTemplateClicked: () => _onFillFromTemplateClicked(context),
          onFoldersClicked: (context) => _onFoldersClicked(context),
          allViewBuilder: (context) => _tabList(
                context,
                questions,
                onEdit: (question) => _onEditClicked(context, question),
                onRemove: (question) => _onRemoveClicked(context, question),
              ),
          folderViewBuilder: (context, folder) => _tabList(
                context,
                selectFolderQuestions(questions, folder),
                onEdit: (question) => _onEditClicked(context, question),
                onRemove: (question) => _onRemoveClicked(context, question),
              )),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _onAddClicked(context),
      ),
    );
  }

  SliverList _tabList(
    BuildContext context,
    List<Question> questions, {
    required OnEdit onEdit,
    required OnRemove onRemove,
  }) {
    return SliverList(
        delegate: SliverChildBuilderDelegate(
      // One more for empty box at the bottom
      childCount: questions.length + 1,
      (context, index) => _listItem(
        questions,
        index,
        context,
        onEdit,
        onRemove,
      ),
    ));
  }

  Widget _listItem(List<Question> questions, int index, BuildContext context,
      OnEdit editCallback, OnRemove removeCallback) {
    if (index >= questions.length) {
      return Container(height: 80);
    }

    return MyQuestion(
      question: questions[index],
      onEdit: editCallback,
      onRemove: removeCallback,
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
