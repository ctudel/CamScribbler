import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gal/gal.dart';

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
    final Uint8List imageBytes =
        context.watch<CanvasProvider>().imageData ?? Uint8List(0);

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
                    imageBytes),
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
                    onPressed: () async {
                      final Drawing drawing = Drawing(
                        title: (_title != '') ? _title : 'Untitled',
                        date: widget.drawing.date,
                        path: await _getImagePath(_title, imageBytes),
                        drawables: widget.drawing.drawables,
                      );
                      _uploadDrawing(drawing);
                      Navigator.of(context).pushReplacementNamed('/drawings');
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
}

Future<String> _getImagePath(String title, Uint8List imageBytes) async {
  // Get Flutter app private storage directory
  final directory = await getApplicationDocumentsDirectory();
  final imagePath = '${directory.path}/${title}_${DateTime.now()}.jpg';

  // Create file at path and write bytes to file
  await File(imagePath).writeAsBytes(imageBytes);

  // Check permissions
  final bool hasAccess = await Gal.hasAccess();

  // request permissions if needed
  bool access = true;
  if (!hasAccess) access = await Gal.requestAccess();

  // Stores the image at given file's path
  if (access)
    try {
      await Gal.putImage(imagePath);
    } catch (e) {
      print('Error while saving image: $e');
    }

  return imagePath;
}
