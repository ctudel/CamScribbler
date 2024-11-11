import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_painter/flutter_painter.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import '../widgets/widgets.dart';

class MyCanvas extends StatefulWidget {
  const MyCanvas({super.key, required this.title});

  final String title;

  @override
  State<MyCanvas> createState() => _MyCanvasState();
}

class _MyCanvasState extends State<MyCanvas> {
  late PainterController _controller;
  static const Color black = Color(0xFF000000);
  ui.Image? backgroundImage;
  late Future<ui.Image> imageFuture;

  @override
  void initState() {
    super.initState();

    _controller = PainterController(
      settings: const PainterSettings(
        freeStyle: FreeStyleSettings(
          mode: FreeStyleMode.draw,
          color: black,
          strokeWidth: 5,
        ),
        scale: ScaleSettings(enabled: true),
      ),
    );

    imageFuture = getUiImage('assets/cat.jpeg');
    initBackground();
  }

  /// Initializes canvas background image
  void initBackground() async {
    final image = await imageFuture;

    setState(() {
      backgroundImage = image;
      _controller.background = image.backgroundDrawable;
    });
  }

  /// Gets an Image asset that is compatible with dart Ui
  Future<ui.Image> getUiImage(String imageAssetPath) async {
    final ByteData assetImageByteData = await rootBundle.load(imageAssetPath);

    final codec = await ui.instantiateImageCodec(
      assetImageByteData.buffer.asUint8List(),
    );

    final ui.Image image = (await codec.getNextFrame()).image;

    return image;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: imageFuture,
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ChangeNotifierProvider<_CanvasSettingProvider>(
            create: (BuildContext _) => _CanvasSettingProvider(),
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.surface,
                title: Text(widget.title),
                actions: [
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.amber,
                    ),
                    onPressed: () {
                      Navigator.of(context).popUntil(ModalRoute.withName('/'));
                      Navigator.of(context).pushReplacementNamed('/save');
                    },
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              body: Stack(
                children: [
                  // Create Canvas with background image
                  Positioned.fill(
                    child: Center(
                      child: AspectRatio(
                          aspectRatio:
                              backgroundImage!.width / backgroundImage!.height,
                          child: FlutterPainter(
                            controller: _controller,
                          )),
                    ),
                  ),
                  // Canvas Settings
                  StrokePicker(controller: _controller),
                  Palette(controller: _controller),
                  Positioned(
                      top: 10,
                      left: 110,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            _controller.undo();
                          });
                        },
                        icon: Icon(PhosphorIcons.arrowCounterClockwise()),
                      ))
                ],
              ),
              // Canvas Toolbar
              bottomNavigationBar:
                  ValueListenableBuilder<PainterControllerValue>(
                valueListenable: _controller,
                builder: (BuildContext context, PainterControllerValue _,
                    Widget? __) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      // Move Canvas
                      ControlButton(
                        controller: _controller,
                        toolType: 'hand',
                      ),
                      // Draw
                      ControlButton(
                        controller: _controller,
                        toolType: 'draw',
                      ),
                      // Erase
                      ControlButton(
                        controller: _controller,
                        toolType: 'eraser',
                      ),
                      // Clear Canvas
                      IconButton(
                        onPressed: _controller.clearDrawables,
                        icon: const Icon(Icons.clear),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        });
  }
}

// =======================================
// Custom Settings Widget for Canvas Tools
// =======================================

class Palette extends StatefulWidget {
  const Palette({
    super.key,
    required this.controller,
  });

  final PainterController controller;

  @override
  State<Palette> createState() => _PaletteState();
}

class _PaletteState extends State<Palette> {
  @override
  Widget build(BuildContext context) {
    _CanvasSettingProvider provider =
        Provider.of<_CanvasSettingProvider>(context);

    return Positioned(
      top: 10,
      left: 60,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Palette Button
          IconButton(
            icon: Icon(
              PhosphorIcons.palette(),
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: () {
              provider.togglePalette();
            },
          ),
          // Color Palette
          if (provider.showPalette)
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                children: <Widget>[
                  const Text(
                    'Color Palette',
                    style: TextStyle(
                      color: Colors.black87,
                    ),
                  ),
                  // First Row of Colors
                  Row(
                    children: <Widget>[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: const CircleBorder(),
                          elevation: 3,
                        ),
                        onPressed: () {
                          widget.controller.freeStyleColor = Colors.orange;
                        },
                        child: Container(),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: const CircleBorder(),
                          elevation: 3,
                        ),
                        onPressed: () {
                          widget.controller.freeStyleColor = Colors.red;
                        },
                        child: Container(),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: const CircleBorder(),
                          elevation: 3,
                        ),
                        onPressed: () {
                          widget.controller.freeStyleColor = Colors.green;
                        },
                        child: Container(),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                          shape: const CircleBorder(),
                          elevation: 3,
                        ),
                        onPressed: () {
                          widget.controller.freeStyleColor =
                              Theme.of(context).colorScheme.surface;
                        },
                        child: Container(),
                      ),
                    ],
                  ),
                  // Second Row of Colors
                  Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: const CircleBorder(),
                          elevation: 3,
                        ),
                        onPressed: () {
                          widget.controller.freeStyleColor = Colors.blue;
                        },
                        child: Container(),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow,
                          shape: const CircleBorder(),
                          elevation: 3,
                        ),
                        onPressed: () {
                          widget.controller.freeStyleColor = Colors.yellow;
                        },
                        child: Container(),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.onSurface,
                          shape: const CircleBorder(),
                          elevation: 3,
                        ),
                        onPressed: () {
                          widget.controller.freeStyleColor =
                              Theme.of(context).colorScheme.onSurface;
                        },
                        child: Container(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class StrokePicker extends StatefulWidget {
  const StrokePicker({
    super.key,
    required this.controller,
  });

  final PainterController controller;

  @override
  State<StrokePicker> createState() => _StrokePickerState();
}

class _StrokePickerState extends State<StrokePicker> {
  @override
  Widget build(BuildContext context) {
    _CanvasSettingProvider provider =
        Provider.of<_CanvasSettingProvider>(context);

    return Positioned(
      top: 10,
      left: 10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Stroke Setting Button
          IconButton(
            icon: Icon(
              PhosphorIcons.gear(),
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: () {
              provider.toggleSlider();
            },
          ),
          // Stroke Slider
          if (provider.showSlider)
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  const Text(
                    'Stroke',
                    style: TextStyle(
                      color: Colors.black87,
                    ),
                  ),
                  Slider.adaptive(
                    min: 2,
                    max: 17,
                    value: widget.controller.freeStyleStrokeWidth,
                    onChanged: (value) {
                      setState(() {
                        widget.controller.freeStyleStrokeWidth = value;
                      });
                    },
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _CanvasSettingProvider with ChangeNotifier {
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
