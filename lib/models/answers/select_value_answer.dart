import 'package:interviewer/models/answers/answer.dart';
import 'package:interviewer/models/answers/answer_type.dart';
import 'package:uuid/uuid.dart';

class SelectValueAnswer extends Answer {
  String id;
  List<SelectValue> values;
  bool isMultipleSelect;

  SelectValueAnswer.empty()
      : this(id: const Uuid().v4(), values: [], isMultipleSelect: false);

  SelectValueAnswer(
      {required this.id, required this.values, required this.isMultipleSelect})
      : super(AnswerType.selectValue);

  SelectValueAnswer copyWith(
      {String? id, List<SelectValue>? values, bool? isMultipleSelect}) {
    return SelectValueAnswer(
        id: id ?? this.id,
        values: values ?? this.values,
        isMultipleSelect: isMultipleSelect ?? this.isMultipleSelect);
  }

  @override
  Answer clone() {
    final newValues = values.map((value) => value.clone()).toList();
    return copyWith(values: newValues);
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

  SelectValue(
      {required this.id, required this.value, required this.isSelected});

  SelectValue copyWith({String? id, String? value, bool? isSelected}) {
    return SelectValue(
        id: id ?? this.id,
        value: value ?? this.value,
        isSelected: isSelected ?? this.isSelected);
  }

  SelectValue clone() {
    return copyWith();
  }
}
