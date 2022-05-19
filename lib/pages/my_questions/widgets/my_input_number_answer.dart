import 'package:flutter/material.dart';
import 'package:interviewer/models/answers/input_number_answer.dart';
import 'package:interviewer/pages/my_questions/widgets/my_text_field.dart';
import 'package:interviewer/utils/doubles.dart';
import 'package:rxdart/rxdart.dart';

typedef OnNumberChanged = void Function(
    InputNumberAnswer answer, double newNumber);

class MyInputNumberAnswer extends StatefulWidget {
  final InputNumberAnswer answer;
  final OnNumberChanged onNumberChanged;
  final int debounceTime;

  const MyInputNumberAnswer(
      {Key? key,
      required this.answer,
      required this.onNumberChanged,
      this.debounceTime = 500})
      : super(key: key);

  @override
  State<MyInputNumberAnswer> createState() => _MyInputNumberAnswerState();
}

class _MyInputNumberAnswerState extends State<MyInputNumberAnswer> {
  TextEditingController? _textController;
  BehaviorSubject<double>? _subject;

  @override
  void initState() {
    super.initState();
    final doubleString = trimTrailingZeroes(widget.answer.value.toString());
    _textController = TextEditingController(text: doubleString);
    _subject = BehaviorSubject<double>.seeded(widget.answer.value);
    _subject?.stream
        .debounceTime(Duration(milliseconds: widget.debounceTime))
        .distinct()
        .listen((value) => widget.onNumberChanged(widget.answer, value));
  }

  @override
  void dispose() {
    _textController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        width: 200,
        child: MyTextField(
          type: MyTextFieldType.number,
          controller: _textController,
          onChanged: _onNumberChanged,
        ),
      ),
    );
  }

  void _onNumberChanged(String newValue) {
    var newValueDouble = double.tryParse(newValue);
    if (newValueDouble != null) {
      _subject?.add(newValueDouble);
    }
  }
}
