import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:cam_scribbler/models/models.dart';
import 'package:cam_scribbler/widgets/widgets.dart';
import 'package:cam_scribbler/database/db.dart' as db;

/// Grid view of drawing gallery
class GridWidget extends StatefulWidget {
  const GridWidget({
    super.key,
    required List<Drawing> myImages,
  }) : _myImages = myImages;

  final List<Drawing> _myImages;

  @override
  State<GridWidget> createState() => _GridWidgetState();
}

class _GridWidgetState extends State<GridWidget> {
  @override
  Widget build(BuildContext context) {
    const TextStyle style = TextStyle(color: Colors.black);

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: MediaQuery.of(context).size.width / 2,
      ),
      itemCount: widget._myImages.length,
      itemBuilder: (context, idx) {
        final Drawing drawing = widget._myImages[idx];
        return GestureDetector(
          onTap: () {
            // Options onpress
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
                          print(
                              'grid rgb: ${widget._myImages[idx].rgbEnabled}');
                          Navigator.of(context).pop();
                          Navigator.of(context).pushReplacementNamed(
                            '/canvas',
                            arguments: widget._myImages[idx],
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.delete_forever),
                        title: const Text('Delete'),
                        onTap: () {
                          deleteDialogue(context, widget._myImages[idx], idx);
                        },
                      ),
                    ],
                  );
                });
          },
          // Image card(s)
          child: ImageCard(drawing: drawing, style: style),
        );
      },
    );
  }

  /// Dialogue to confirm delete drawing
  Future<void> deleteDialogue(BuildContext context, Drawing drawing, int index) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Are you sure you want to proceed?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                _delete(drawing, index);
                Navigator.of(context).popUntil(ModalRoute.withName('/drawings'));
              },
            ),
          ],
        );
      },
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
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                ),
                onPressed: () {
                  final Drawing updatedDrawing = Drawing(
                    id: drawing.id,
                    title: title ?? drawing.title,
                    date: drawing.date,
                    bgPath: drawing.bgPath,
                    drawingPath: drawing.drawingPath,
                    drawables: drawing.drawables,
                    rgbEnabled: drawing.rgbEnabled,
                  );
                  _updateName(updatedDrawing, drawing.id ?? -1, index);
                  Navigator.of(context).pop();
                },
                child: const Text('Save'),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.onSurface,
                ),
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
    await db.updateDrawing(drawing, id);
    setState(() {
      widget._myImages[index] = drawing;
    });
  }

  Future<void> _delete(Drawing drawing, index) async {
    await db.deleteDrawing(drawing);
    setState(() {
      widget._myImages.removeAt(index);
    });
  }
}
