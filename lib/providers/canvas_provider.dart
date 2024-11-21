import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class CanvasProvider with ChangeNotifier {
  bool _showSlider = false;
  bool _showPalette = false;
  Uint8List? _imageData; // temp image

  bool get showSlider => _showSlider;
  bool get showPalette => _showPalette;
  Uint8List? get imageData => _imageData;

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

  void createTempImage(Uint8List? byteData) {
    _imageData = byteData;
    notifyListeners();
  }
}
