import 'package:uuid/uuid.dart';

class Question {
  String id;
  String text;
  String? answerId;
  String? folderId;
  String companyId;
  String? note;

  Question.empty(this.companyId)
      : id = const Uuid().v4(),
        text = '';

  Question(
      {required this.id,
      required this.text,
      required this.answerId,
      this.folderId,
      required this.companyId,
      this.note});

  Question copyWith(
      {String? id,
      String? text,
      String? answerId,
      String? folderId,
      String? companyId,
      String? note}) {
    return Question(
      id: id ?? this.id,
      text: text ?? this.text,
      answerId: answerId ?? this.answerId,
      folderId: folderId ?? this.folderId,
      companyId: companyId ?? this.companyId,
      note: note ?? this.note,
    );
  }

  Question clone() {
    return copyWith();
  }
}
