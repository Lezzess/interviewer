import 'package:flutter/material.dart';
import 'package:interviewer/models/company.dart';
import 'package:interviewer/states/questions_state.dart';

class CompaniesState with ChangeNotifier {
  final List<Company> companies;

  CompaniesState(this.companies);

  void add(String name) {
    final company = Company.withName(name);
    companies.add(company);
    notifyListeners();
  }

  void update(Company company, String name) {
    company.name = name;
    notifyListeners();
  }

  void remove(Company company, QuestionsState questionsState) {
    companies.remove(company);
    questionsState.removeCompanyQuestions(company);
    notifyListeners();
  }
}
