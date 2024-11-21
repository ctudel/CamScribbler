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
const MainScaffold drawings =
    MainScaffold(title: 'My Drawings', pageIndex: 1, child: DrawingGallery());

// Settings Page
const MainScaffold settings =
    MainScaffold(title: 'Settings', pageIndex: 2, child: Settings());

// // Save Image Page
// const SaveDrawing savePage = SaveDrawing();

// ====================
// Routes w/ parameters
// ====================

// OnGenerate Routes
MaterialPageRoute genRoutes(RouteSettings settings) {
  return switch (settings.name) {
    '/canvas' => canvasPage(settings.arguments as Drawing),
    '/save' => saveDrawingPage(settings.arguments as Drawing),
    _ => throw 'No route provided'
  };
}

canvasPage(args) {
  return MaterialPageRoute<MyCanvas>(builder: (context) {
    return MyCanvas(
      title: 'Drawing Canvas',
      imagePath: args.path, // extract the path from Drawing object in args
    );
  });
}

saveDrawingPage(args) {
  return MaterialPageRoute<MyCanvas>(builder: (context) {
    return SaveDrawing(
      drawing: args,
    );
  });
}
