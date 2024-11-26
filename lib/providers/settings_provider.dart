import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  bool _isGrid = false;

  bool get isGrid => _isGrid;

  void setGrid() {
    _isGrid = true;
    notifyListeners();
  }

  void setCarousel() {
    _isGrid = false;
  }

  void toggleView() {
    _isGrid = !_isGrid;
    notifyListeners();
  }
}
