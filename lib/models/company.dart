import 'package:uuid/uuid.dart';

class Company {
  String id;
  String name;
  bool isTemplate;

  Company.withName(this.name, {this.isTemplate = false})
      : id = const Uuid().v4();

  Company({required this.id, required this.name, this.isTemplate = false});

  Map<String, dynamic> toDb() {
    return {'id': id, 'name': name, 'is_template': isTemplate};
  }

  Company.fromDb(Map<String, dynamic> entry)
      : this(
          id: entry['id'],
          name: entry['name'],
          isTemplate: entry['is_template'] == 1,
        );

  Company clone() {
    return Company(
      id: id,
      name: name,
      isTemplate: isTemplate,
    );
  }
}
