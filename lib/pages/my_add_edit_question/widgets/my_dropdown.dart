import 'package:flutter/material.dart';

typedef OnValueChanged<T> = void Function(T? newValue);
typedef ToStringConverter<T> = String Function(T value);

class MyDropdown<T> extends StatelessWidget {
  final List<T> values;
  final T? selectedValue;
  final OnValueChanged<T> onValueChanged;
  final ToStringConverter<T>? toStringConverter;
  final String? hintText;
  final String? labelText;

  const MyDropdown(
      {super.key,
      required this.values,
      required this.selectedValue,
      required this.onValueChanged,
      this.toStringConverter,
      this.hintText,
      this.labelText});

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
        builder: (FormFieldState<String> state) => DropdownButtonHideUnderline(
              child: InputDecorator(
                decoration: InputDecoration(
                    hintText: hintText,
                    labelText: labelText,
                    labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.primaryContainer),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    alignLabelWithHint: true),
                isEmpty: selectedValue == null,
                child: Theme(
                  data: Theme.of(context).copyWith(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent),
                  child: DropdownButton<T>(
                      value: selectedValue,
                      isDense: true,
                      items: values.map(_dropdownMenuItem).toList(),
                      onChanged: onValueChanged),
                ),
              ),
            ));
  }

  DropdownMenuItem<T> _dropdownMenuItem(T value) {
    final stringValue = toStringConverter != null
        ? toStringConverter!(value)
        : value.toString();
    return DropdownMenuItem(value: value, child: Text(stringValue));
  }
}
