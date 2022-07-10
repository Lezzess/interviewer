import 'package:flutter/material.dart';
import 'package:interviewer/models/answers/input_text_answer.dart';
import 'package:interviewer/pages/my_questions/widgets/my_input_text_answer.dart';

class MyEditInputTextAnswer extends StatefulWidget {
  final InputTextAnswer answer;

  const MyEditInputTextAnswer({super.key, required this.answer});

  @override
  State<MyEditInputTextAnswer> createState() => _MyEditInputTextAnswerState();
}

class _MyEditInputTextAnswerState extends State<MyEditInputTextAnswer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [_multilineCheckbox(context), _textField()],
    );
  }

  Widget _multilineCheckbox(context) {
    return Row(
      children: [
        Text(
          'Multiline',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Expanded(
            child: Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            height: 30,
            child: Switch(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: widget.answer.isMultiline,
                onChanged: _onMultilineChanged),
          ),
        ))
      ],
    );
  }

  Widget _textField() {
    return MyInputTextAnswer(
      answer: widget.answer,
      enabled: false,
    );
  }

  void _onMultilineChanged(bool? newValue) {
    setState(() {
      widget.answer.isMultiline = newValue ?? false;
    });
  }
}
