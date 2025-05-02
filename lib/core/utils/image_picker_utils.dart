import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerUtils {
  // image picker
  static dynamic pickImage(ImageSource imageSource) async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? image;
    try {
      image = await imagePicker.pickImage(source: imageSource);

      if (image != null) {
        Uint8List bytes = await image.readAsBytes();
        // developer.log('File size in bytes: ${bytes.length}');
        return bytes;
      }
    } catch (e, stackTrace) {
      debugPrint("Error picking image :: $e\n$stackTrace");
    }
  }
}
