import 'package:flutter/material.dart';
import 'package:interviewer/models/answers/input_text_answer.dart';
import 'package:interviewer/pages/my_questions/widgets/my_text_field.dart';
import 'package:interviewer/states/questions_state.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class MyInputTextAnswer extends StatefulWidget {
  final InputTextAnswer answer;
  final int debounceTime;
  final bool enabled;

  const MyInputTextAnswer({
    super.key,
    required this.answer,
    this.debounceTime = 500,
    this.enabled = true,
  });

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
        .listen((value) =>
            context.read<QuestionsState>().setAnswerText(widget.answer, value));
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyTextField(
      enabled: widget.enabled,
      type: MyTextFieldType.text,
      controller: _textController,
      onChanged: _onTextChanged,
      inputType: widget.answer.isMultiline
          ? TextInputType.multiline
          : TextInputType.text,
      hintText: 'Type in text',
      minLines: widget.answer.isMultiline ? 2 : 1,
      maxLines: widget.answer.isMultiline ? 5 : 1,
    );
  }

  void _onTextChanged(String newValue) {
    _subject.add(newValue.trim());
  }
}
