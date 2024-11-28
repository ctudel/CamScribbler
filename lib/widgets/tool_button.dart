import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter_painter/flutter_painter.dart';

class ToolButton extends StatelessWidget {
  const ToolButton({
    super.key,
    required this.controller,
    required this.toolType,
  });

  final PainterController controller;
  final String toolType;

  @override
  Widget build(BuildContext context) {
    // canvas tool
    final FreeStyleMode mode = switch (toolType) {
      'draw' => FreeStyleMode.draw,
      'eraser' => FreeStyleMode.erase,
      _ => FreeStyleMode.none,
    };

    // button icon
    final IconData toolIcon = switch (toolType) {
      'draw' => PhosphorIcons.pencil(),
      'eraser' => PhosphorIcons.eraser(),
      'hand' => PhosphorIcons.hand(),
      _ => Icons.check_box,
    };

    return IconButton(
      icon: Icon(
        toolIcon,
        color: controller.freeStyleMode == mode ? Colors.amber : null,
      ),
      onPressed: () {
        controller.freeStyleMode =
            controller.freeStyleMode != mode ? mode : FreeStyleMode.none;
      },
    );
  }
}
