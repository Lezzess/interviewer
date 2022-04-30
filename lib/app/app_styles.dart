import 'package:flutter/material.dart';

extension AppTextStyle on TextTheme {
  TextStyle? get questionText => headlineMedium;
  TextStyle? get answerText => questionText?.copyWith(fontSize: 20);
}
