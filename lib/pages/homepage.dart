import 'dart:io';

import 'package:cam_scribbler/models/models.dart';
import 'package:cam_scribbler/widgets/my_navbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Homepage extends StatefulWidget {
  const Homepage({
    super.key,
  });

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  File image = File('');

  /// Take a photo or pick photo one from the gallery
  Future<File?> pickImage(ImageSource source) async {
    try {
      final XFile? image = await ImagePicker().pickImage(source: source);

      if (image == null) return null; // no image picked or taken

      return (this.image = File(image.path));
    } catch (e) {
      print('Failed to pick image $e');
    }
    return null; // in case try fails
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Spacing
          SizedBox(
            height: MediaQuery.of(context).size.height / 8,
          ),
          // Page Header
          const Text(
            'CamScribbler',
            style: TextStyle(fontSize: 48),
          ),
          // Spacing
          SizedBox(
            height: MediaQuery.of(context).size.height / 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  // Camera Button
                  IconButton(
                    onPressed: () async {
                      final File? imageFile =
                          await pickImage(ImageSource.camera);

                      if (imageFile != null) {
                        Navigator.pushNamed(
                          context,
                          '/canvas',
                          arguments: Drawing(
                            title: 'placeholder',
                            date: '',
                            path: imageFile.path,
                            drawables: '',
                          ),
                        );
                      }
                    },
                    icon: Icon(
                      Icons.camera_alt,
                      size: 80,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const Text('Take Photo'),
                ],
              ),
              Column(
                children: [
                  // Upload Button
                  IconButton(
                    onPressed: () async {
                      final File? imageFile =
                          await pickImage(ImageSource.gallery);

                      if (imageFile != null) {
                        Navigator.pushNamed(
                          context,
                          '/canvas',
                          arguments: Drawing(
                            title: 'placeholder',
                            date: '',
                            path: imageFile.path,
                            drawables: '',
                          ),
                        );
                      }
                    },
                    icon: Icon(
                      Icons.upload,
                      size: 80,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const Text('Upload Image'),
                ],
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: const MyNavBar(pageIndex: 0),
    );
  }
}
