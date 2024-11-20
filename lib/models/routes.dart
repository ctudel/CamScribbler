import 'package:cam_scribbler/models/models.dart';
import 'package:flutter/material.dart';

import '../pages/pages.dart';
import '../main.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  '/': (context) => homepage,
  '/drawings': (context) => drawings,
  '/settings': (context) => settings,
  '/save': (context) => savePage,
};

// Homepage
const Homepage homepage = Homepage();

// Drawing Gallery
const MainScaffold drawings =
    MainScaffold(title: 'My Drawings', pageIndex: 1, child: DrawingGallery());

// Settings Page
const MainScaffold settings =
    MainScaffold(title: 'Settings', pageIndex: 2, child: Settings());

// Save Image Page
const SaveDrawing savePage = SaveDrawing();

// ====================
// Routes w/ parameters
// ====================

// OnGenerate Routes
MaterialPageRoute genRoutes(RouteSettings settings) {
  if (settings.name == '/canvas')
    return canvasPage(settings.arguments as Drawing);
  else
    throw 'No route provided';
}

canvasPage(args) {
  return MaterialPageRoute<MyCanvas>(builder: (context) {
    return MyCanvas(
      title: 'Drawing Canvas',
      imagePath: args.path, // extract the path from Drawing object in args
    );
  });
}
