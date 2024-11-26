import 'package:cam_scribbler/models/models.dart';
import 'package:flutter/material.dart';

import '../pages/pages.dart';
import '../main.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  '/': (context) => homepage,
  '/drawings': (context) => drawings,
  '/settings': (context) => settings,
};

// Homepage
const Homepage homepage = Homepage();

// Drawing Gallery
const MainScaffold drawings = MainScaffold(
    title: 'Drawing Gallery', pageIndex: 1, child: DrawingGallery());

// Settings Page
const MainScaffold settings =
    MainScaffold(title: 'Settings', pageIndex: 2, child: Settings());

// ====================
// Routes w/ parameters
// ====================

/// Generates paramter routes
MaterialPageRoute genRoutes(RouteSettings settings) {
  return switch (settings.name) {
    '/canvas' => canvasPage(settings.arguments as Drawing),
    '/save' => saveDrawingPage(settings.arguments as Drawing),
    _ => throw 'No route provided'
  };
}

/// Drawing Canvas Page Route
MaterialPageRoute<MyCanvas> canvasPage(args) {
  return MaterialPageRoute<MyCanvas>(builder: (context) {
    return MyCanvas(
      title: 'Drawing Canvas',
      imagePath: args.path, // extract the path from Drawing object in args
    );
  });
}

/// Save Drawing Page Route
MaterialPageRoute<SaveDrawing> saveDrawingPage(args) {
  return MaterialPageRoute<SaveDrawing>(builder: (context) {
    return SaveDrawing(
      drawing: args,
    );
  });
}
