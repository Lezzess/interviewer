import 'package:interviewer/extensions/immutable_list.dart';
import 'package:interviewer/extensions/immutable_map.dart';
import 'package:interviewer/models/company.dart';
import 'package:interviewer/redux/app/actions.dart';
import 'package:interviewer/redux/app/state.dart';
import 'package:interviewer/redux/companies/selectors.dart';
import 'package:interviewer/redux/companies/state.dart';

class AddCompanyAction extends AppAction<CompaniesState> {
  final String name;

  AddCompanyAction({required this.name});

  @override
  CompaniesState handle(CompaniesState state) {
    final newCompany = Company.withName(name);

    final newById = state.byId.iadd(newCompany.id, newCompany);
    final newAll = state.all.iadd(newCompany.id);

    final newState = state.copyWith(byId: newById, all: newAll);
    return newState;
  }
}

class UpdateCompanyAction extends AppAction<CompaniesState> {
  final String id;
  final String name;

  UpdateCompanyAction({required this.id, required this.name});

  @override
  CompaniesState handle(CompaniesState state) {
    final company = selectCompany(state, id);
    final newCompany = company.copyWith(id: id, name: name);

    final newById = state.byId.ireplace(id, newCompany);
    final newState = state.copyWith(byId: newById);

    return newState;
  }
}

class RemoveCompanyAction extends AppAction<AppState> {
  final String id;

  RemoveCompanyAction(this.id);

  @override
  AppState handle(AppState state) {
    final newById = state.companies.byId.iremove(id);
    final newAll = state.companies.all.iremove(id);
    final newStateCompanies =
        state.companies.copyWith(byId: newById, all: newAll);

    final newCompaniesQuestions =
        state.questions.companiesQuestions.iremove(id);
    final newStateQuestions =
        state.questions.copyWith(companiesQuestions: newCompaniesQuestions);

    final newState = state.copyWith(
      companies: newStateCompanies,
      questions: newStateQuestions,
    );

    return newState;
  }
}
