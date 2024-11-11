import 'package:cam_scribbler/widgets/my_navbar.dart';
import 'package:flutter/material.dart';
import 'pages.dart';

class Homepage extends StatelessWidget {
  const Homepage({
    super.key,
  });

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
                    onPressed: null,
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
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const MyCanvas(title: 'Canvas'),
                      ),
                    ),
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
