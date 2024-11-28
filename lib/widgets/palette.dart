import 'package:flutter/material.dart';
import 'package:flutter_painter/flutter_painter.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:cam_scribbler/providers/providers.dart';

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
    CanvasProvider provider = Provider.of<CanvasProvider>(context);

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
