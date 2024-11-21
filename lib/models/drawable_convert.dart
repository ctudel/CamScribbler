import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_painter/flutter_painter.dart';

String drawablesToJson(PainterController controller) {
  List<Map<String, dynamic>> listOfMaps = []; // stores converted drawables

  // Make all drawables into JSON format
  for (final Drawable drawable in controller.drawables) {
    if (drawable is FreeStyleDrawable) {
      final FreeStyleDrawable fsDrawable = drawable;
      listOfMaps.add({
        'type': 'FreeStyleDrawable',
        'stroke': fsDrawable.strokeWidth,
        'color': fsDrawable.color.value,
        'path':
            fsDrawable.path // Create a list of maps containing offset values
                .map((offset) => {
                      'dx': offset.dx,
                      'dy': offset.dy,
                    })
                .toList(),
      });
    }

    if (drawable is EraseDrawable) {
      final EraseDrawable erasable = drawable;
      listOfMaps.add({
        'type': 'EraseDrawable',
        'stroke': erasable.strokeWidth,
        'path': erasable.path
            .map((offset) => {
                  'dx': offset.dx,
                  'dy': offset.dy,
                })
            .toList(),
      });
    }
  }

  return jsonEncode(listOfMaps);
}

List<Drawable> jsonToDrawables(String jsonStr) {
  final json = jsonDecode(jsonStr);
  final List<Drawable> drawables = <Drawable>[];

  // Process and convert all JSON objects to Drawable(s)
  for (final d in json) {
    // Debugging purposes only
    // print(d['path']);
    // print(d['color']);
    // print(d['stroke']);

    // Recreate list of Offsets from map(s) values
    //  json decode defaults to dynamic. Recast to proper type
    final List<Offset> list = List<Offset>.from(d['path']
        .map((innerMap) => Offset(innerMap['dx'], innerMap['dy']))
        .toList());

    if (d['type'] == 'FreeStyleDrawable') {
      drawables.add(FreeStyleDrawable(
        strokeWidth: d['stroke'],
        color: Color(d['color']),
        path: list,
      ));
    }

    if (d['type'] == 'EraseDrawable') {
      drawables.add(EraseDrawable(
        strokeWidth: d['stroke'],
        path: list,
      ));
    }
  }

  return drawables;
}
