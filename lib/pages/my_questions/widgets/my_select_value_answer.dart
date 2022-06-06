import 'package:flutter/material.dart';
import 'package:interviewer/models/answers/select_value_answer.dart';
import 'package:collection/collection.dart';

typedef OnAnswerSelected = void Function(
    SelectValueAnswer answer, SelectValue value, bool isSelected);

class MySelectValueAnswer extends StatelessWidget {
  final SelectValueAnswer answer;
  final OnAnswerSelected onChanged;

  const MySelectValueAnswer(
      {super.key, required this.answer, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: answer.values.length,
      itemBuilder: (context, index) =>
          answer.isMultipleSelect ? _checkbox(index) : _radio(index),
    );
  }

  Widget _checkbox(int index) {
    return CheckboxListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(answer.values[index].value),
      onChanged: (isSelected) =>
          onChanged(answer, answer.values[index], isSelected ?? false),
      value: answer.values[index].isSelected,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  Widget _radio(int index) {
    final selectedValue =
        answer.values.firstWhereOrNull((element) => element.isSelected);
    return RadioListTile<SelectValue?>(
        contentPadding: EdgeInsets.zero,
        toggleable: true,
        controlAffinity: ListTileControlAffinity.leading,
        title: Text(answer.values[index].value),
        value: answer.values[index],
        groupValue: selectedValue,
        onChanged: (value) => onChanged(
            answer, answer.values[index], value == answer.values[index]));
  }
}
