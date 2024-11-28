import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_painter/flutter_painter.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:cam_scribbler/widgets/widgets.dart';
import 'package:cam_scribbler/providers/providers.dart';
import 'package:cam_scribbler/models/models.dart';

class MyCanvas extends StatefulWidget {
  const MyCanvas({
    super.key,
    this.id,
    required this.title,
    required this.imagePath,
    required this.drawables,
  });

  // TODO: use id when editing photos
  //
  // use a provider to record current photo and update
  // database once saving
  //
  // Otherwise, null will follow standard procedure
  final int? id;
  final String title;
  final String imagePath;
  final String drawables;

  @override
  State<MyCanvas> createState() => _MyCanvasState();
}

class _MyCanvasState extends State<MyCanvas> {
  static const Color black = Color(0xFF000000);
  ui.Image? backgroundImage;
  late Future<ui.Image> imageFuture;
  late PainterController _controller;

  // TODO: Make image black and white
  /// Gets an Image asset that is compatible with dart Ui
  Future<ui.Image> getUiImage(String imageAssetPath) async {
    final Uint8List bytes = await File(imageAssetPath).readAsBytes();
    final codec = await ui.instantiateImageCodec(bytes);
    final ui.Image image = (await codec.getNextFrame()).image;
    return image;
  }

  /// Shows a dialog and resolves to true when the user has indicated that they
  /// want to pop.
  ///
  /// A return value of null indicates a desire not to pop, such as when the
  /// user has dismissed the modal without tapping a button.
  Future<bool?> _showBackDialog() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('You have unsaved changes.'),
          content: const Text(
            'Are you sure you want to leave this page?',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelMedium,
              ),
              child: const Text('Nevermind'),
              onPressed: () {
                Navigator.pop<bool>(context, false);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelMedium,
              ),
              child: const Text('Leave Without Saving'),
              onPressed: () {
                Navigator.pop<bool>(context, true);
              },
            ),
          ],
        );
      },
    );
  }

  /// Initializes canvas background image
  void initBackground() async {
    final image = await imageFuture;
    setState(() {
      backgroundImage = image;
      _controller.background = image.backgroundDrawable;
    });
  }

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
      drawables: (widget.drawables != '')
          ? jsonToDrawables(widget.drawables)
          : <Drawable>[],
    );

    imageFuture = getUiImage(widget.imagePath);
    initBackground();
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

          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (bool didPop, Object? result) async {
              if (didPop) return;
              // Prompt user before they leave the page
              final bool shouldPop = await _showBackDialog() ?? false;
              if (context.mounted && shouldPop) Navigator.pop(context);
            },
            child: Scaffold(
              // AppBar
              appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.surface,
                title: const Text('Drawing Canvas'),
                actions: [
                  // Save button
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.amber,
                    ),
                    onPressed: () async {
                      // Render drawing as an image
                      final ui.Image renderedImage =
                          await _controller.renderImage(Size(
                              backgroundImage!.width * 1.0,
                              backgroundImage!.height * 1.0));

                      final Uint8List? byteData = await renderedImage.pngBytes;

                      if (context.mounted) {
                        // Store image temporarily for user to potentially save w/o reconversion
                        context
                            .read<CanvasProvider>()
                            .createTempImage(byteData);

                        // Navigate to save page and pass arguments
                        Navigator.of(context).pushReplacementNamed(
                          '/save',
                          arguments: Drawing(
                            id: widget.id,
                            title: widget.title,
                            date: DateFormat.yMMMd('en_US')
                                .format(DateTime.now()),
                            path: widget.imagePath,
                            drawables: drawablesToJson(_controller),
                          ),
                        );
                      }
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
