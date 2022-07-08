import 'package:uuid/uuid.dart';

class Folder {
  final String id;
  final String name;
  final int order;

  Folder.withName(this.name, this.order) : id = const Uuid().v4();

  Folder({required this.id, required this.name, required this.order});

  Folder copyWith({String? id, String? name, int? order}) {
    return Folder(
      id: id ?? this.id,
      name: name ?? this.name,
      order: order ?? this.order,
    );
  }

  Folder clone() {
    return copyWith();
  }
}
