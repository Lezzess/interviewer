import 'package:uuid/uuid.dart';

class Company {
  final String id;
  final String name;
  bool isTemplate;

  Company.withName(this.name, {this.isTemplate = false})
      : id = const Uuid().v4();

  Company({required this.id, required this.name, this.isTemplate = false});

  Company copyWith({String? id, String? name, bool? isTemplate}) {
    return Company(
      id: id ?? this.id,
      name: name ?? this.name,
      isTemplate: isTemplate ?? this.isTemplate,
    );
  }

  Company clone() {
    return copyWith();
  }
}
