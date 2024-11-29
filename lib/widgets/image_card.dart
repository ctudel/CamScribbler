import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cam_scribbler/models/models.dart';

class ImageCard extends StatelessWidget {
  const ImageCard({
    super.key,
    required this.drawing,
    required this.style,
  });

  final Drawing drawing;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
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
                    File(drawing.drawingPath),
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
  }
}
