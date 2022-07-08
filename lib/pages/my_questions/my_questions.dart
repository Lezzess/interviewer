import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:interviewer/models/company.dart';
import 'package:interviewer/models/folder.dart';
import 'package:interviewer/models/question.dart';
import 'package:interviewer/pages/my_add_edit_question/my_add_edit_question.dart';
import 'package:interviewer/pages/my_add_edit_question/my_add_edit_question_arguments.dart';
import 'package:interviewer/pages/my_questions/widgets/my_question.dart';
import 'package:interviewer/pages/my_questions/widgets/my_sticky_app_bar.dart';
import 'package:interviewer/pages/routes.dart';
import 'package:interviewer/redux/answers/selectors.dart';
import 'package:interviewer/redux/app/state.dart';
import 'package:interviewer/redux/companies/selectors.dart';
import 'package:interviewer/redux/folders/selectors.dart';
import 'package:interviewer/redux/questions/actions.dart';
import 'package:interviewer/redux/questions/selectors.dart';
import 'package:quiver/core.dart';
import 'package:redux/redux.dart';

class MyQuestions extends StatelessWidget {
  final String companyId;

  const MyQuestions({super.key, required this.companyId});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      converter: (store) => _ViewModel(
          questions: selectCompanyQuestions(store.state.questions, companyId),
          company: selectCompany(store.state.companies, companyId),
          onFillFromTemplate: () => _onFillFromTemplateClicked(store),
          onAdd: () => _onAddClicked(context, store),
          onEdit: (questionId) => _onEditClicked(context, questionId, store),
          onRemove: (questionId) =>
              _onRemoveClicked(context, questionId, store)),
      builder: (context, viewModel) => Scaffold(
        body: MyStickyAppBar(
            title: Text(viewModel.company.name),
            isFillFromTemplateAvailable: viewModel.questions.isEmpty,
            onFillFromTemplateClicked: viewModel.onFillFromTemplate,
            onFoldersClicked: (context) => _onFoldersClicked(context),
            allViewBuilder: (context) => _tabList(
                  context,
                  viewModel.questions,
                  onEdit: viewModel.onEdit,
                  onRemove: viewModel.onRemove,
                ),
            folderViewBuilder: (context, folder) => _tabList(
                  context,
                  selectFolderQuestions(viewModel.questions, folder),
                  onEdit: viewModel.onEdit,
                  onRemove: viewModel.onRemove,
                )),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: viewModel.onAdd,
        ),
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
      questionId: questions[index].id,
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

  void _onFillFromTemplateClicked(Store<AppState> store) {
    store.dispatch(FillQuestionsFromTemplateAction(companyId));
  }

  void _onFoldersClicked(BuildContext context) async {
    await Navigator.pushNamed(context, Routes.folders);
  }

  void _onAddClicked(BuildContext context, Store<AppState> store) async {
    final args = MyAddEditQuestionArguments(companyId: companyId);
    final result = await Navigator.pushNamed(
      context,
      Routes.addQuestion,
      arguments: args,
    );

    if (result != null) {
      final output = result as AddEditQuestionOutput;
      store.dispatch(AddQuestionAction(
        question: output.question,
        answer: output.answer,
        folder: output.folder,
      ));
    }
  }

  void _onEditClicked(
      BuildContext context, String questionId, Store<AppState> store) async {
    final question = selectQuestion(store.state.questions, questionId);
    final answer = selectAnswer(store.state.answers, question.answerId);
    final folder = selectFolder(store.state.folders, question.folderId);

    final args = MyAddEditQuestionArguments(
        question: question,
        asnwer: answer,
        folder: folder,
        companyId: companyId);
    final result = await Navigator.pushNamed(context, Routes.editQuestion,
        arguments: args);

    if (result != null) {
      final output = result as AddEditQuestionOutput;
      store.dispatch(UpdateQuestionAction(
        oldQuestionId: questionId,
        newQuestion: output.question,
        newAnswer: output.answer,
        newFolder: output.folder,
      ));
    }
  }

  void _onRemoveClicked(
      BuildContext context, String questionId, Store<AppState> store) {
    store.dispatch(RemoveQuestionAction(questionId));
  }
}

typedef OnFillFromTemplate = void Function();
typedef OnAdd = void Function();

class _ViewModel {
  final List<Question> questions;
  final Company company;
  final OnFillFromTemplate onFillFromTemplate;
  final OnAdd onAdd;
  final OnEdit onEdit;
  final OnRemove onRemove;

  _ViewModel({
    required this.questions,
    required this.company,
    required this.onFillFromTemplate,
    required this.onAdd,
    required this.onEdit,
    required this.onRemove,
  });

  @override
  bool operator ==(Object other) =>
      other is _ViewModel &&
      other.runtimeType == runtimeType &&
      listEquals(other.questions, questions) &&
      other.company == company;

  @override
  int get hashCode => hash3(
        questions.hashCode,
        company.hashCode,
        hashList(questions),
      );
}
