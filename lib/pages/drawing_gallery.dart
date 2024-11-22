import 'dart:io';

import 'package:flutter/material.dart';

import 'package:cam_scribbler/models/models.dart';
import 'package:cam_scribbler/database/db.dart' as db;

class DrawingGallery extends StatefulWidget {
  const DrawingGallery({super.key});

  @override
  State<DrawingGallery> createState() => _DrawingGalleryState();
}

class _DrawingGalleryState extends State<DrawingGallery> {
  late List<Drawing> _myImages = <Drawing>[];

  @override
  void initState() {
    super.initState();
    _getDrawings();
  }

  void _getDrawings() async {
    final drawings = await db.getDrawings();
    // Debugging purposes only
    print(drawings);
    setState(() {
      _myImages = drawings;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(_myImages.runtimeType);
    print(_myImages);

    final Image image = Image.asset(
      'assets/cat.jpeg',
      fit: BoxFit.contain,
    );

    const style = TextStyle(color: Colors.black);

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
