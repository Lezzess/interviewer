import 'package:interviewer/models/answers/answer.dart';

class SelectValueAnswer extends Answer {
  String id;
  List<SelectValue> values;
  bool isMultipleSelect;

  SelectValueAnswer(
      {required this.id, required this.values, required this.isMultipleSelect});

  SelectValueAnswer copyWith(
      {String? id, List<SelectValue>? values, bool? isMultipleSelect}) {
    return SelectValueAnswer(
        id: id ?? this.id,
        values: values ?? this.values,
        isMultipleSelect: isMultipleSelect ?? this.isMultipleSelect);
  }
}

class SelectValue {
  String id;
  String value;
  bool isSelected;

  SelectValue(
      {required this.id, required this.value, required this.isSelected});

  SelectValue copyWith({String? id, String? value, bool? isSelected}) {
    return SelectValue(
        id: id ?? this.id,
        value: value ?? this.value,
        isSelected: isSelected ?? this.isSelected);
  }
}
