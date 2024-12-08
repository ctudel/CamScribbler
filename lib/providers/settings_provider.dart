import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  bool _isGrid = true;
  int? _coloredPhotos = 0;

  bool get isGrid => _isGrid;
  int? get coloredPhotos => _coloredPhotos;

  void setGrid() {
    _isGrid = true;
    notifyListeners();
  }

  void setCarousel() {
    _isGrid = false;
  }

  void setRgb(int? coloredPhotos) {
    _coloredPhotos = coloredPhotos;
    notifyListeners();
  }
}
