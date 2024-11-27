import 'dart:io';

import 'package:cam_scribbler/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:cam_scribbler/models/models.dart';
import 'package:cam_scribbler/database/db.dart' as db;

/// Carousel view for drawings gallery
class CarouselWidget extends StatefulWidget {
  const CarouselWidget({
    super.key,
    required List<Drawing> myImages,
  }) : _myImages = myImages;

  final List<Drawing> _myImages;

  @override
  State<CarouselWidget> createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  @override
  Widget build(BuildContext context) {
    /// Generate list of widgets using drawings
    final List<Widget> list = List.generate(widget._myImages.length, (index) {
      final Drawing drawing = widget._myImages[index];
      return ImageCard(
        drawing: drawing,
        style: const TextStyle(color: Colors.black, fontSize: 20),
      );
    });

    // Drawing Carousel
    return CarouselView(
      itemExtent: MediaQuery.of(context).size.width,
      itemSnapping: true,
      onTap: (int idx) {
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return Wrap(
                children: <Widget>[
                  ListTile(
                    leading: PhosphorIcon(PhosphorIcons.pencil()),
                    title: const Text('Rename'),
                    onTap: () {
                      Navigator.of(context).pop();
                      _showMyDialogue(context, widget._myImages[idx], idx);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.edit_square),
                    title: const Text('Edit'),
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed(
                        '/canvas',
                        arguments: widget._myImages[idx],
                      );
                    },
                  ),
                ],
              );
            });
      },
      children: list,
    );
  }

  /// Popup dialogue to rename saved drawing
  Future<void> _showMyDialogue(
      BuildContext context, Drawing drawing, int index) {
    String? title = drawing.title;

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Enter New Title'),
            content: TextField(
              textAlign: TextAlign.center,
              onChanged: (String? value) {
                title = value;
              },
            ),
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            actions: [
              FilledButton(
                style: FilledButton.styleFrom(backgroundColor: Colors.amber),
                onPressed: () {
                  final Drawing updatedDrawing = Drawing(
                    id: drawing.id,
                    title: title ?? drawing.title,
                    date: drawing.date,
                    path: drawing.path,
                    drawables: drawing.drawables,
                  );
                  _updateName(updatedDrawing, drawing.id ?? -1, index);
                  Navigator.of(context).pop();
                },
                child: const Text('Save'),
              ),
              FilledButton(
                style: FilledButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
            ],
          );
        });
  }

  /// Update drawing name in database
  Future<void> _updateName(Drawing drawing, int id, int index) async {
    await db.renameDrawing(drawing, id);
    setState(() {
      widget._myImages[index] = drawing;
    });
  }
}
