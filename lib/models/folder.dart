import 'package:uuid/uuid.dart';

class Folder {
  String id;
  String name;
  int order;

  Folder.withName(this.name, this.order) : id = const Uuid().v4();

  Folder({required this.id, required this.name, required this.order});

  Map<String, dynamic> toDb() {
    return {'id': id, 'name': name, 'order_no': order};
  }

  Folder.fromDb(Map<String, dynamic> entry)
      : this(
          id: entry['id'],
          name: entry['name'],
          order: entry['order_no'],
        );

  Folder clone() {
    return Folder(
      id: id,
      name: name,
      order: order,
    );
  }
}
