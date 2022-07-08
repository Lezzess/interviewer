import 'package:interviewer/models/company.dart';
import 'package:interviewer/redux/companies/state.dart';

List<Company> selectAllCompanies(CompaniesState state) {
  final ids = state.all;
  final companies = ids.map((id) => state.byId[id]!).toList();

  return companies;
}

Company selectCompany(CompaniesState state, String id) {
  return state.byId[id]!;
}

Company selectTemplateCompany(CompaniesState state) {
  final companies = selectAllCompanies(state);
  final template = companies.firstWhere((company) => company.isTemplate);

  return template;
}
