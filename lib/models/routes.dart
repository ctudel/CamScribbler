import 'package:flutter/material.dart';

import '../pages/pages.dart';
import '../main.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  '/': (context) => homepage,
  '/canvas': (context) => canvas,
  '/drawings': (context) => drawings,
  '/settings': (context) => settings,
  '/save': (context) => savePage,
};

// Drawing Canvas
const MyCanvas canvas = MyCanvas(title: 'Canvas');

// Homepage
const Homepage homepage = Homepage();

// Drawing Gallery
const MainScaffold drawings =
    MainScaffold(title: 'My Drawings', pageIndex: 1, child: DrawingGallery());

// Settings Page
const MainScaffold settings =
    MainScaffold(title: 'Settings', pageIndex: 2, child: Settings());

// Save Image Page
const savePage = SaveDrawing();
