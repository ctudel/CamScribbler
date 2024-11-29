import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  bool _isGrid = true;
  bool? _coloredPhotos = false;

  bool get isGrid => _isGrid;
  bool? get coloredPhotos => _coloredPhotos;

  void setGrid() {
    _isGrid = true;
    notifyListeners();
  }

  void setCarousel() {
    _isGrid = false;
  }

  void setRgb(bool? coloredPhotos) {
    _coloredPhotos = coloredPhotos;
    notifyListeners();
  }
}
