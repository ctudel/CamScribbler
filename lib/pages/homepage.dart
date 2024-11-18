import 'dart:io';

import 'package:cam_scribbler/widgets/my_navbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'pages.dart';

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
      // Take photo or pick from gallery
      final XFile? image =
          await ImagePicker().pickImage(source: ImageSource.camera);

      if (image == null) return null; // no image picked or taken

      return (this.image = File(image.path));
    } catch (e) {
      print('Failed to pick image $e');
    }
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
          // Header
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

                      if (imageFile != null)
                        Navigator.of(context).pushReplacementNamed('/canvas');
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
                    onPressed: null,
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
