import 'package:flutter/material.dart';
import 'package:interviewer/models/answers/input_text_answer.dart';
import 'package:interviewer/pages/my_questions/widgets/my_text_field.dart';
import 'package:rxdart/rxdart.dart';

typedef OnTextChanged = void Function(InputTextAnswer answer, String newText);

class MyInputTextAnswer extends StatefulWidget {
  final InputTextAnswer answer;
  final OnTextChanged onTextChanged;
  final int debounceTime;

  const MyInputTextAnswer(
      {super.key,
      required this.answer,
      required this.onTextChanged,
      this.debounceTime = 500});

  @override
  State<MyInputTextAnswer> createState() => _MyInputTextAnswerState();
}

class _MyInputTextAnswerState extends State<MyInputTextAnswer> {
  late TextEditingController _textController;
  late BehaviorSubject<String> _subject;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.answer.text);
    _subject = BehaviorSubject<String>.seeded(widget.answer.text);
    _subject.stream
        .skip(1)
        .debounceTime(Duration(milliseconds: widget.debounceTime))
        .distinct()
        .listen((value) => widget.onTextChanged(widget.answer, value));
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: MyTextField(
          type: MyTextFieldType.text,
          controller: _textController,
          onChanged: _onTextChanged),
    );
  }

  void _onTextChanged(String newValue) {
    _subject.add(newValue.trim());
  }
}
