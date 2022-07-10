import 'package:interviewer/models/answers/answer.dart';
import 'package:interviewer/models/answers/answer_type.dart';
import 'package:uuid/uuid.dart';

class SelectValueAnswer extends Answer {
  List<SelectValue> values;
  bool isMultiselect;

  SelectValueAnswer.empty(String questionId)
      : this(
          id: const Uuid().v4(),
          values: [],
          isMultiselect: false,
          questionId: questionId,
        );

  SelectValueAnswer({
    required String id,
    required this.values,
    required this.isMultiselect,
    required String questionId,
  }) : super(id, AnswerType.selectValue, questionId);

  Map<String, dynamic> toDb() {
    return {
      'id': id,
      'type': type.name,
      'is_multiselect': isMultiselect ? 1 : 0,
      'question_id': questionId
    };
  }

  SelectValueAnswer.fromDb(
    Map<String, dynamic> entry,
  ) : this(
          id: entry['id'],
          values: [],
          isMultiselect: entry['is_multiselect'] == 1,
          questionId: entry['question_id'],
        );

  @override
  Answer clone({bool generateNewGuid = false}) {
    final id = generateNewGuid ? const Uuid().v4() : this.id;
    final newValues = values
        .map((value) => value.clone(generateNewGuid: generateNewGuid))
        .toList();
    return SelectValueAnswer(
      id: id,
      values: newValues,
      isMultiselect: isMultiselect,
      questionId: questionId,
    );
  }
}

class SelectValue {
  String id;
  String value;
  bool isSelected;

  SelectValue.empty()
      : id = const Uuid().v4(),
        value = '',
        isSelected = false;

  SelectValue({
    required this.id,
    required this.value,
    required this.isSelected,
  });

  Map<String, dynamic> toDb(String answerId) {
    return {
      'id': id,
      'value': value,
      'is_selected': isSelected ? 1 : 0,
      'answer_id': answerId
    };
  }

  SelectValue.fromDb(Map<String, dynamic> entry)
      : this(
          id: entry['id'],
          value: entry['value'],
          isSelected: entry['is_selected'] == 1,
        );

  SelectValue clone({bool generateNewGuid = false}) {
    final id = generateNewGuid ? const Uuid().v4() : this.id;
    return SelectValue(
      id: id,
      value: value,
      isSelected: isSelected,
    );
  }
}
