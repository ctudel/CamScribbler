import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cam_scribbler/widgets/widgets.dart';
import 'package:cam_scribbler/models/models.dart';
import 'package:cam_scribbler/providers/providers.dart';

class SaveDrawing extends StatelessWidget {
  const SaveDrawing({super.key, required this.drawing});

  final Drawing drawing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              // FIXME: Implement this skeleton to properly store this values
              TextFormField(
                decoration: const InputDecoration(hintText: 'Untitled'),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.memory(
                    context.watch<CanvasProvider>().imageData as Uint8List),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${drawing.date}'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.onSurface,
                    ),
                    onPressed: () =>
                        Navigator.of(context).pushReplacementNamed('/'),
                    child: Text(
                      'Discard',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.surface),
                    ),
                  ),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.amber,
                    ),
                    onPressed: () =>
                        Navigator.of(context).pushReplacementNamed('/drawings'),
                    child: const Text(
                      'Done',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        bottomNavigationBar: const MyNavBar(
          pageIndex: 2,
        ),
      ),
    );
  }
}
