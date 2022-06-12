import 'package:flutter/material.dart';

typedef OnTextChanged = void Function(String newValue);

class MyTextField extends StatelessWidget {
  final MyTextFieldType type;
  final TextEditingController? controller;
  final OnTextChanged? onChanged;
  final bool enabled;

  const MyTextField(
      {super.key,
      required this.type,
      this.controller,
      this.onChanged,
      this.enabled = true});

  @override
  Widget build(BuildContext context) {
    final keyboardType = type == MyTextFieldType.number
        ? TextInputType.number
        : TextInputType.text;
    final hintText =
        type == MyTextFieldType.number ? "Type in number" : "Type in text";
    final maxLines = type == MyTextFieldType.number ? 1 : 5;

    return TextField(
      enabled: enabled,
      controller: controller,
      onChanged: onChanged,
      minLines: 1,
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
                  width: 2, color: Theme.of(context).colorScheme.secondary)),
          disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  width: 1, color: Theme.of(context).colorScheme.primary))),
    );
  }
}

enum MyTextFieldType { number, text }
