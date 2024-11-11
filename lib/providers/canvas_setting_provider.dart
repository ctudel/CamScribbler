import 'package:flutter/material.dart';

class CanvasSettingProvider with ChangeNotifier {
  bool _showSlider = false;
  bool _showPalette = false;

  bool get showSlider => _showSlider;
  bool get showPalette => _showPalette;

  void toggleSlider() {
    if (_showPalette) _showPalette = !_showPalette;
    _showSlider = !_showSlider;
    notifyListeners();
  }

  void togglePalette() {
    if (_showSlider) _showSlider = !_showSlider;
    _showPalette = !_showPalette;
    notifyListeners();
  }

  void closeSettings() {
    _showSlider = false;
    _showPalette = false;
    notifyListeners();
  }
}
