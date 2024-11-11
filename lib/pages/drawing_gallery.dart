import 'package:flutter/material.dart';

class DrawingGallery extends StatelessWidget {
  const DrawingGallery({super.key});

  @override
  Widget build(BuildContext context) {
    final Image image = Image.asset(
      'assets/cat.jpeg',
      fit: BoxFit.contain,
    );

    // FIXME: Fetch from a database of file paths instead of static generation
    final List<Map> myImages =
        List.generate(10, (index) => {"id": index, "image": image});

    const style = TextStyle(color: Colors.black);

    // FIXME: Skeleton Grid of drawings
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 2 / 2,
      ),
      itemCount: myImages.length,
      itemBuilder: (context, index) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      myImages[index]["image"],
                      const Text(
                        'My Drawing',
                        style: style,
                      ),
                      const Text(
                        'Nov 11, 2024',
                        style: style,
                      ),
                    ],
                  ),
                )),
          ),
        );
      },
    );
  }
}
