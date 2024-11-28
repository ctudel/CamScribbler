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
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
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
                          print(widget._myImages[idx].title);
                          Navigator.of(context).pop();
                          Navigator.of(context).pushNamed(
                            '/canvas',
                            arguments: widget._myImages[idx],
                          );
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

  // TODO: Segment this into a separate model for grid and carousel
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
                    path: drawing.path,
                    drawables: drawing.drawables,
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
}
