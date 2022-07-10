import 'package:flutter/material.dart';
import 'package:interviewer/db/db.dart';
import 'package:interviewer/models/company.dart';
import 'package:interviewer/states/questions_state.dart';
import 'package:interviewer/repositories/companies.dart' as rcompanies;

class CompaniesState with ChangeNotifier {
  final List<Company> companies;

  CompaniesState(this.companies);

  void add(String name) async {
    await Db.transaction((txn) async {
      final company = Company.withName(name);
      companies.add(company);

      notifyListeners();

      await rcompanies.add(txn, company);
    });
  }

  void update(Company company, String name) async {
    await Db.transaction((txn) async {
      company.name = name;
      notifyListeners();
      await rcompanies.update(txn, company);
    });
  }

  void remove(Company company, QuestionsState questionsState) async {
    await Db.transaction((txn) async {
      companies.remove(company);
      questionsState.removeCompanyQuestions(txn, company);

      notifyListeners();

      await rcompanies.remove(txn, company);
    });
  }
}
