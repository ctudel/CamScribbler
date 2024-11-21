import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cam_scribbler/database/db.dart' as db;
import 'package:cam_scribbler/widgets/widgets.dart';
import 'package:cam_scribbler/models/models.dart';
import 'package:cam_scribbler/providers/providers.dart';

class SaveDrawing extends StatefulWidget {
  const SaveDrawing({super.key, required this.drawing});

  final Drawing drawing;

  @override
  State<SaveDrawing> createState() => _SaveDrawingState();
}

class _SaveDrawingState extends State<SaveDrawing> {
  String _title = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(hintText: 'Untitled'),
                textAlign: TextAlign.center,
                onChanged: (String value) => {
                  setState(() {
                    _title = value;
                  }),
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.memory(
                    // rebuild with rendered image
                    context.watch<CanvasProvider>().imageData as Uint8List),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${widget.drawing.date}'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.onSurface,
                    ),
                    onPressed: () {
                      _getDrawings();
                      Navigator.of(context).pushReplacementNamed('/');
                    },
                    child: Text(
                      'Discard',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.surface),
                    ),
                  ),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.amber,
                    ),
                    onPressed: () {
                      final Drawing drawing = Drawing(
                        title: _title,
                        date: widget.drawing.date,
                        path: widget.drawing.path,
                        drawables: widget.drawing.drawables,
                      );
                      _uploadDrawing(drawing);
                    },
                    child: const Text(
                      'Done',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        bottomNavigationBar: const MyNavBar(
          pageIndex: 2,
        ),
      ),
    );
  }
}

void _uploadDrawing(Drawing drawing) async {
  await db.saveDrawing(drawing);
  print(
      'successfully uploaded Drawing: ${drawing.title}, ${drawing.date}, ${drawing.path}, ${drawing.drawables}');
}

void _getDrawings() async {
  final drawings = await db.getDrawings();
  print(drawings);
}
