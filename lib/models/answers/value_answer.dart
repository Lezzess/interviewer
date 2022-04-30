class SelectValueAnswer {
  String id;
  List<SelectValue> values;
  bool isMultipleSelect;

  SelectValueAnswer(
      {required this.id, required this.values, required this.isMultipleSelect});
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
