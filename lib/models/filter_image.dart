import 'dart:typed_data';
import 'package:image/image.dart' as img;

Future<Uint8List> convertImageToGrayscale(Uint8List imageData) async {
  img.Image image = img.decodeImage(imageData) as img.Image;
  img.grayscale(image);
  return img.encodePng(image);
}
