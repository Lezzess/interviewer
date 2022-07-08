import 'package:interviewer/models/company.dart';

class CompaniesState {
  final Map<String, Company> byId;
  final List<String> all;

  CompaniesState({
    required this.byId,
    required this.all,
  });

  CompaniesState copyWith({
    Map<String, Company>? byId,
    List<String>? all,
  }) {
    return CompaniesState(
      byId: byId ?? this.byId,
      all: all ?? this.all,
    );
  }
}
