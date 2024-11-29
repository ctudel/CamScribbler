import 'dart:io';

import 'package:cam_scribbler/models/models.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:cam_scribbler/providers/providers.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({super.key, required this.source});

  final String source;

  @override
  Widget build(BuildContext context) {
    final SettingsProvider provider = Provider.of<SettingsProvider>(context);

    return IconButton(
      onPressed: () async {
        final File? imageFile = (source == 'gallery')
            ? await pickImage(ImageSource.gallery)
            : await pickImage(ImageSource.camera);

        if (context.mounted && imageFile != null) {
          Navigator.pushNamed(
            context,
            '/canvas',
            arguments: Drawing(
              title: 'Untitled',
              date: '',
              bgPath: imageFile.path,
              drawingPath: '',
              drawables: '[]',
              rgbEnabled: provider.coloredPhotos,
            ),
          );
        }
      },
      icon: Icon(
        (source == 'gallery') ? Icons.upload : Icons.camera_alt,
        size: 80,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}

/// Take a photo or pick photo one from the gallery
Future<File?> pickImage(ImageSource source) async {
  try {
    final XFile? image = await ImagePicker().pickImage(source: source);
    if (image == null) return null; // no image picked or taken
    return (File(image.path));
  } catch (e) {
    print('Failed to pick image $e');
  }
  return null; // in case try fails
}
