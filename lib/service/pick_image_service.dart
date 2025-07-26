import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

class PickImageService {
  static Future<Uint8List?> pickImageFromCamera() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile == null) return null;
    return await pickedFile.readAsBytes();
  }
}
