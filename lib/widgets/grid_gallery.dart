import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cam_scribbler/models/models.dart';

/// Grid view of drawing gallery
class GridWidget extends StatelessWidget {
  const GridWidget({
    super.key,
    required List<Drawing> myImages,
  }) : _myImages = myImages;

  final List<Drawing> _myImages;

  @override
  Widget build(BuildContext context) {
    const TextStyle style = TextStyle(color: Colors.black);

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
      ),
      itemCount: _myImages.length,
      itemBuilder: (context, index) {
        final Drawing drawing = _myImages[index];
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Flexible(
                      child: Image.file(
                        File(drawing.path),
                      ),
                    ),
                    Text(
                      drawing.title,
                      style: style,
                    ),
                    Text(
                      drawing.date,
                      style: style,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
