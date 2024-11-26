import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cam_scribbler/models/models.dart';
import 'package:cam_scribbler/widgets/widgets.dart';
import 'package:cam_scribbler/providers/providers.dart';
import 'package:cam_scribbler/database/db.dart' as db;

class DrawingGallery extends StatefulWidget {
  const DrawingGallery({super.key});

  @override
  State<DrawingGallery> createState() => _DrawingGalleryState();
}

class _DrawingGalleryState extends State<DrawingGallery> {
  late List<Drawing> _myImages = <Drawing>[];

  void _getDrawings() async {
    final drawings = await db.getDrawings();
    // Debugging purposes only
    setState(() {
      _myImages = drawings;
    });
  }

  @override
  void initState() {
    super.initState();
    _getDrawings();
  }

  @override
  Widget build(BuildContext context) {
    final bool isGrid = context.watch<SettingsProvider>().isGrid;

    return (isGrid)
        ? GridWidget(myImages: _myImages)
        : CarouselWidget(myImages: _myImages);
  }
}
