import 'package:flutter/material.dart';

class Style {
  const Style();

  // decorations
  static InputDecoration searchInputDecoration() => const InputDecoration(
        labelText: 'Поиск по загаловке',
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.greenAccent,
            width: 5.0,
          ),
        ),
        contentPadding: EdgeInsets.all(12),
        isDense: true,
      );

  // styles
  static TextStyle w500() => const TextStyle(fontWeight: FontWeight.w500);
  static TextStyle w600() => const TextStyle(fontWeight: FontWeight.w600);
}
