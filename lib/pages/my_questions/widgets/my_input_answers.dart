import 'package:flutter/material.dart';
import 'package:interviewer/models/answers/input_number_answer.dart';
import 'package:interviewer/models/answers/input_text_answer.dart';

class MyInputNumberAnswer extends StatelessWidget {
  final InputNumberAnswer answer;

  const MyInputNumberAnswer({Key? key, required this.answer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        width: 200,
        child: const MyTextField(
          type: MyTextFieldType.number,
        ),
      ),
    );
  }
}

class MyInputTextAnswer extends StatelessWidget {
  final InputTextAnswer answer;

  const MyInputTextAnswer({Key? key, required this.answer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: const MyTextField(type: MyTextFieldType.text),
    );
  }
}

class MyTextField extends StatelessWidget {
  final MyTextFieldType type;

  const MyTextField({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final keyboardType = type == MyTextFieldType.number
        ? TextInputType.number
        : TextInputType.text;
    final hintText =
        type == MyTextFieldType.number ? "Type in number" : "Type in text";
    final maxLines = type == MyTextFieldType.number ? null : 1;

    return Align(
      alignment: Alignment.centerLeft,
      child: TextField(
        maxLines: maxLines,
        textAlign: TextAlign.left,
        style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        keyboardType: keyboardType,
        textAlignVertical: TextAlignVertical.bottom,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
            hintText: hintText,
            isDense: true,
            contentPadding: const EdgeInsets.all(15),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    width: 1, color: Theme.of(context).colorScheme.primary)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    width: 2, color: Theme.of(context).colorScheme.secondary))),
      ),
    );
  }
}

enum MyTextFieldType { number, text }
