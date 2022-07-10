import 'package:flutter/material.dart';
import 'package:interviewer/models/answers/select_value_answer.dart';
import 'package:collection/collection.dart';
import 'package:interviewer/states/questions_state.dart';
import 'package:provider/provider.dart';

typedef OnAnswerSelected = void Function(
    SelectValueAnswer answer, SelectValue value, bool isSelected);

class MySelectValueAnswer extends StatelessWidget {
  final SelectValueAnswer answer;

  const MySelectValueAnswer({super.key, required this.answer});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: answer.values.length,
      itemBuilder: (context, index) => answer.isMultiselect
          ? _checkbox(context, index)
          : _radio(context, index),
    );
  }

  Widget _checkbox(BuildContext context, int index) {
    return CheckboxListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(answer.values[index].value),
      onChanged: (isSelected) => _onAnswerChanged(
        context,
        answer.values[index],
        isSelected ?? false,
      ),
      value: answer.values[index].isSelected,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  Widget _radio(BuildContext context, int index) {
    final selectedValue =
        answer.values.firstWhereOrNull((element) => element.isSelected);
    return RadioListTile<SelectValue?>(
        contentPadding: EdgeInsets.zero,
        toggleable: true,
        controlAffinity: ListTileControlAffinity.leading,
        title: Text(answer.values[index].value),
        value: answer.values[index],
        groupValue: selectedValue,
        onChanged: (value) => _onAnswerChanged(
              context,
              answer.values[index],
              value == answer.values[index],
            ));
  }

  void _onAnswerChanged(
    BuildContext context,
    SelectValue value,
    bool isSelected,
  ) {
    final state = context.read<QuestionsState>();
    state.selectAnswerValue(answer, value, isSelected);
  }
}
