import 'package:flutter/material.dart';

extension AppTextStyle on TextTheme {
  TextStyle? get questionText => headlineMedium?.copyWith(fontSize: 20);
}
