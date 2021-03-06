import 'package:flutter/material.dart';

typedef OnTextChanged = void Function(String newValue);

class MyTextField extends StatelessWidget {
  final MyTextFieldType type;
  final TextEditingController? controller;
  final OnTextChanged? onChanged;
  final bool enabled;
  final TextInputType inputType;
  final String? hintText;
  final int? minLines;
  final int? maxLines;

  const MyTextField({
    super.key,
    required this.type,
    this.controller,
    this.onChanged,
    this.enabled = true,
    required this.inputType,
    this.hintText,
    this.minLines,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: enabled,
      controller: controller,
      onChanged: onChanged,
      minLines: minLines,
      maxLines: maxLines,
      textAlign: TextAlign.left,
      style: TextStyle(color: Theme.of(context).colorScheme.secondary),
      keyboardType: inputType,
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
