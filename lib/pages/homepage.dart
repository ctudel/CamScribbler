import 'dart:io';

import 'package:cam_scribbler/widgets/widgets.dart';

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
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  // Camera Button
                  ActionButton(source: 'camera'),
                  Text('Take Photo'),
                ],
              ),
              Column(
                children: [
                  // Upload from Gallery Button
                  ActionButton(source: 'gallery'),
                  Text('Upload Image'),
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
