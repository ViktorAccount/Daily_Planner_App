import 'package:flutter/material.dart';

class FontSizeProvider with ChangeNotifier {
  double _fontSize = 1.0; // Default text scale factor

  double get fontSize => _fontSize;

  void updateFontSize(double newSize) {
    _fontSize = newSize;
    notifyListeners();
  }
}
