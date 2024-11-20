import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:cam_scribbler/models/models.dart';
import 'package:cam_scribbler/widgets/widgets.dart';
import 'package:cam_scribbler/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_painter/flutter_painter.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class MyCanvas extends StatefulWidget {
  const MyCanvas({
    super.key,
    required this.title,
    required this.imagePath,
  });

  final String title;
  final String imagePath;

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

    imageFuture = getUiImage(widget.imagePath);
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
    final Uint8List bytes = await File(imageAssetPath).readAsBytes();

    final codec = await ui.instantiateImageCodec(bytes);

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

          if (!snapshot.hasData) throw 'No photo found';

          // TODO: Take this idea and try to save it into database
          List<Drawable> drawables = [
            FreeStyleDrawable(strokeWidth: 5, path: [
              const Offset(142.0, 112.5),
              const Offset(142.0, 116.0),
              const Offset(139.0, 119.0),
              const Offset(137.5, 124.0),
              const Offset(136.0, 128.5),
              const Offset(134.0, 135.0),
              const Offset(132.5, 140.0),
              const Offset(131.0, 148.0),
              const Offset(131.0, 159.0),
              const Offset(129.5, 164.0),
              const Offset(129.5, 170.0),
              const Offset(129.5, 175.0),
              const Offset(128.0, 178.0),
              const Offset(128.0, 184.5),
              const Offset(128.0, 188.0),
              const Offset(129.5, 192.5),
              const Offset(129.5, 194.0),
              const Offset(131.0, 194.0),
              const Offset(136.0, 196.0),
              const Offset(137.5, 197.5),
              const Offset(140.5, 197.5),
              const Offset(144.0, 199.0),
              const Offset(145.5, 199.0),
              const Offset(148.5, 200.5),
              const Offset(155.0, 204.0),
              const Offset(158.0, 205.5),
              const Offset(172.5, 210.0),
              const Offset(190.0, 213.5),
              const Offset(198.0, 213.5),
              const Offset(212.5, 213.5),
              const Offset(225.5, 213.5),
              const Offset(236.5, 213.5),
              const Offset(244.5, 213.5),
              const Offset(248.0, 212.0),
              const Offset(249.5, 212.0),
              const Offset(251.0, 212.0),
              const Offset(252.5, 215.0),
              const Offset(244.5, 237.5),
              const Offset(243.0, 242.0),
              const Offset(241.5, 247.0),
              const Offset(240.0, 252.0),
              const Offset(238.0, 255.0)
            ])
          ];
          _controller.addDrawables(drawables);
          // TODO: Call these when necessary
          // final jsonStr = _drawablesToJSON(drawables, _controller);
          // print(_drawablesToJSON(drawables, _controller));

          return ChangeNotifierProvider<CanvasSettingProvider>(
            // Provider for palette options
            create: (BuildContext _) => CanvasSettingProvider(),
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

// FIXME: Create a wrapper class and create toJSON and fromJSON methods utilizing drawable fields
// NOTE: This may be sufficient, and another helper method for _JSONtoDrawables could be created
/// Encode all drawables as JSON
String _drawablesToJSON(
    List<Drawable> drawables, PainterController controller) {
  List<Map<String, dynamic>> listOfMaps = []; // stores converted drawables

  // Make all drawables into JSON format
  for (final Drawable drawable in drawables) {
    if (drawable is FreeStyleDrawable) {
      final FreeStyleDrawable fsDrawable = drawable;
      // NOTE: expected data to store into "drawable" in JSON
      listOfMaps.add({
        'type': 'FreeStyleDrawable',
        'stroke': fsDrawable.strokeWidth,
        'color': '${fsDrawable.color}',
        'path': fsDrawable.path
            .map((offset) => {
                  'dx': offset.dx,
                  'dy': offset.dy,
                })
            .toList(),
      });
    }

    if (drawable is EraseDrawable) {
      final EraseDrawable erasable = drawable;
      listOfMaps.add({
        'type': 'EraseDrawable',
        'stroke': erasable.strokeWidth,
        'path': erasable.path
            .map((offset) => {
                  'dx': offset.dx,
                  'dy': offset.dy,
                })
            .toList(),
      });
    }
  }

  return jsonEncode(listOfMaps);
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
    CanvasSettingProvider provider =
        Provider.of<CanvasSettingProvider>(context);

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
    CanvasSettingProvider provider =
        Provider.of<CanvasSettingProvider>(context);

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
