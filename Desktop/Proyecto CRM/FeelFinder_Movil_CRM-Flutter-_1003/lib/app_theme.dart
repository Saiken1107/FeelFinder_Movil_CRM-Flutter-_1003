import 'package:flutter/material.dart';

const Color _customColor = Color.fromARGB(255, 179, 151, 203);

const List<Color> _colorThemes = [
  _customColor,
  Colors.blue,
  Colors.teal,
  Colors.green,
  Colors.yellow,
  Colors.orange,
  Colors.pink,
  Colors.black12,
];

class AppTheme {
  final int selectedColor;

  AppTheme({this.selectedColor = 0})
      : assert(selectedColor >= 0 && selectedColor < _colorThemes.length,
            'Colors must be between 0 and${_colorThemes.length - 1}');

  ThemeData theme() {
    return ThemeData(
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
        colorSchemeSeed: _colorThemes[selectedColor],
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: _customColor, foregroundColor: Colors.white));
  }
}
