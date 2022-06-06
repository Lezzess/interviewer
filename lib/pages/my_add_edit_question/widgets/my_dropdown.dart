import 'package:flutter/material.dart';

typedef OnValueChanged = void Function(String? newValue);

class MyDropdown extends StatelessWidget {
  final List<String> values;
  final String? selectedValue;
  final OnValueChanged onValueChanged;

  const MyDropdown(
      {super.key,
      required this.values,
      required this.selectedValue,
      required this.onValueChanged});

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
        builder: (FormFieldState<String> state) => DropdownButtonHideUnderline(
              child: InputDecorator(
                decoration: InputDecoration(
                    hintText: 'Select answer type',
                    labelText: 'What type of answer?',
                    labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.primaryContainer),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    alignLabelWithHint: true),
                isEmpty: selectedValue == null,
                child: Theme(
                  data: Theme.of(context).copyWith(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent),
                  child: DropdownButton<String>(
                      value: selectedValue,
                      isDense: true,
                      items: values
                          .map((e) => DropdownMenuItem<String>(
                              value: e, child: Text(e)))
                          .toList(),
                      onChanged: onValueChanged),
                ),
              ),
            ));
  }
}
