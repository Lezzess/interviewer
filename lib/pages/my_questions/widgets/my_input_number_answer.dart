import 'package:flutter/material.dart';
import 'package:interviewer/models/answers/input_number_answer.dart';
import 'package:interviewer/pages/my_questions/widgets/my_text_field.dart';
import 'package:interviewer/utils/doubles.dart';
import 'package:rxdart/rxdart.dart';

typedef OnNumberChanged = void Function(
    InputNumberAnswer answer, double? newNumber);

class MyInputNumberAnswer extends StatefulWidget {
  final InputNumberAnswer? answer;
  final OnNumberChanged? onNumberChanged;
  final int debounceTime;
  final bool enabled;

  const MyInputNumberAnswer(
      {super.key,
      this.answer,
      this.onNumberChanged,
      this.debounceTime = 500,
      this.enabled = true})
      : assert(!enabled || enabled && answer != null,
            'If input number field is enabled, it should have answer != null');

  @override
  State<MyInputNumberAnswer> createState() => _MyInputNumberAnswerState();
}

class _MyInputNumberAnswerState extends State<MyInputNumberAnswer> {
  late TextEditingController _textController;
  late BehaviorSubject<double?> _subject;

  @override
  void initState() {
    super.initState();
    final doubleString =
        trimTrailingZeroes(widget.answer?.value?.toString() ?? "");
    _textController = TextEditingController(text: doubleString);
    _subject = BehaviorSubject<double?>.seeded(widget.answer?.value);
    _subject.stream
        .skip(1)
        .debounceTime(Duration(milliseconds: widget.debounceTime))
        .distinct()
        .listen((value) => widget.onNumberChanged?.call(widget.answer!, value));
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: MyTextField(
        enabled: widget.enabled,
        type: MyTextFieldType.number,
        controller: _textController,
        onChanged: _onNumberChanged,
        inputType: TextInputType.number,
        hintText: 'Type in number',
      ),
    );
  }

  void _onNumberChanged(String newValue) {
    newValue = newValue.trim();

    if (newValue == "") {
      _subject.add(null);
    }

    var newValueDouble = double.tryParse(newValue);
    if (newValueDouble != null) {
      _subject.add(newValueDouble);
    }
  }
}
