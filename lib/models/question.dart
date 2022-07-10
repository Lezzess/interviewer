import 'package:interviewer/models/answers/answer.dart';
import 'package:uuid/uuid.dart';

class Question {
  String id;
  String companyId;
  String? text;
  String? note;
  Answer? answer;
  String? folderId;

  Question.empty(this.companyId) : id = const Uuid().v4();

  Question({
    required this.id,
    required this.companyId,
    this.text,
    this.note,
    this.answer,
    this.folderId,
  });

  Map<String, dynamic> toDb() {
    return {
      'id': id,
      'text': text,
      'note': note,
      'folder_id': folderId,
      'company_id': companyId
    };
  }

  Question.fromDb(Map<String, dynamic> entry)
      : this(
          id: entry['id'],
          text: entry['text'],
          note: entry['note'],
          folderId: entry['folder_id'],
          companyId: entry['company_id'],
        );

  Question clone({bool generateNewGuid = false, String? companyId}) {
    final id = generateNewGuid ? const Uuid().v4() : this.id;
    final answerCopy = answer?.clone();
    return Question(
      id: id,
      companyId: companyId ?? this.companyId,
      text: text,
      note: note,
      answer: answerCopy,
      folderId: folderId,
    );
  }
}
