import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cam_scribbler/models/models.dart';

/// Carousel view for drawings gallery
class CarouselWidget extends StatelessWidget {
  const CarouselWidget({
    super.key,
    required List<Drawing> myImages,
  }) : _myImages = myImages;

  final List<Drawing> _myImages;

  @override
  Widget build(BuildContext context) {
    const TextStyle style = TextStyle(color: Colors.black, fontSize: 20);

    /// Generate list of widgets using drawings
    final List<Widget> list = List.generate(_myImages.length, (index) {
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
    });

    return CarouselView(
      itemExtent: MediaQuery.of(context).size.width,
      itemSnapping: true,
      children: list,
    );
  }
}
