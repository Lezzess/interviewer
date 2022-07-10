import 'package:flutter/material.dart';
import 'package:interviewer/extensions/indexed_iterable.dart';
import 'package:interviewer/models/answers/select_value_answer.dart';
import 'package:uuid/uuid.dart';

class MyOptionsAnswer extends StatefulWidget {
  final SelectValueAnswer answer;

  const MyOptionsAnswer({super.key, required this.answer});

  @override
  State<MyOptionsAnswer> createState() => _MyOptionsAnswerState();
}

class _MyOptionsAnswerState extends State<MyOptionsAnswer> {
  late SelectValueAnswer _answer;
  late List<TextEditingController> _textControllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    _answer = widget.answer;
    _textControllers = _answer.values
        .map((value) => TextEditingController(text: value.value))
        .toList();

    _focusNodes = _answer.values.map((value) => FocusNode()).toList();

    super.initState();
  }

  @override
  void dispose() {
    for (final controller in _textControllers) {
      controller.dispose();
    }

    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _multipleSelectCheckbox(context),
        _optionsList(),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }

  Widget _optionsList() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Column(
            children: _textControllers
                .mapIndexed((controller, i) => Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _textControllers[i],
                            focusNode: _focusNodes[i],
                            decoration: const InputDecoration(
                              hintText: 'Type in text',
                            ),
                            onChanged: (newText) =>
                                _changeAnswerText(newText, i),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        IconButton(
                          padding: const EdgeInsets.only(
                              top: 20, left: 15, right: 5),
                          constraints: const BoxConstraints(),
                          icon: Icon(
                            Icons.delete,
                            color: Theme.of(context).unselectedWidgetColor,
                          ),
                          onPressed: () => _removeOption(i),
                        )
                      ],
                    ))
                .toList(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TextButton.icon(
              style: TextButton.styleFrom(
                  primary: Theme.of(context).colorScheme.onPrimary,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.fromLTRB(10, 5, 20, 5)),
              icon: const Icon(Icons.add),
              label: const Text('Add item'),
              onPressed: _addOption,
            ),
          )
        ],
      ),
    );
  }

  Widget _multipleSelectCheckbox(BuildContext context) {
    return Row(
      children: [
        Text(
          'Multiple select',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Expanded(
            child: Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            height: 30,
            child: Switch(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: _answer.isMultiselect,
                onChanged: _onMultipleSelectChanged),
          ),
        ))
      ],
    );
  }

  void _onMultipleSelectChanged(bool? newValue) {
    setState(() {
      _answer.isMultiselect = newValue ?? false;
      for (final value in _answer.values) {
        value.isSelected = false;
      }
    });
  }

  void _changeAnswerText(String newText, int i) {
    _answer.values[i].value = newText.trim();
  }

  void _addOption() {
    _answer.values
        .add(SelectValue(id: const Uuid().v4(), value: '', isSelected: false));
    setState(() {
      _textControllers.add(TextEditingController());

      final newFocusNode = FocusNode();
      _focusNodes.add(newFocusNode);
      newFocusNode.requestFocus();
    });
  }

  void _removeOption(int i) {
    _answer.values.removeAt(i);
    setState(() {
      final controller = _textControllers.removeAt(i);
      final focusNode = _focusNodes.removeAt(i);

      controller.dispose();
      focusNode.dispose();
    });
  }
}
