import 'package:flutter/material.dart';
import 'package:flutter_painter/flutter_painter.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:cam_scribbler/providers/providers.dart';

class StrokePicker extends StatefulWidget {
  const StrokePicker({
    super.key,
    required this.controller,
  });

  final PainterController controller;

  @override
  State<StrokePicker> createState() => _StrokePickerState();
}

class _StrokePickerState extends State<StrokePicker> {
  @override
  Widget build(BuildContext context) {
    CanvasProvider provider = Provider.of<CanvasProvider>(context);

    return Positioned(
      top: 10,
      left: 10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Stroke Setting Button
          IconButton(
            icon: Icon(
              PhosphorIcons.gear(),
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: () {
              provider.toggleSlider();
            },
          ),
          // Stroke Slider
          if (provider.showSlider)
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  const Text(
                    'Stroke',
                    style: TextStyle(
                      color: Colors.black87,
                    ),
                  ),
                  Slider.adaptive(
                    min: 2,
                    max: 17,
                    value: widget.controller.freeStyleStrokeWidth,
                    onChanged: (value) {
                      setState(() {
                        widget.controller.freeStyleStrokeWidth = value;
                      });
                    },
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}
