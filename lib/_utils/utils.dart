import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class Utils {
  static Future<List<int>?> pickImageAsBytes(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: source);

    if (image != null) {
      return await image.readAsBytes();
    } else {
      print('No image selected.');
      return null;
    }
  }

  static Future<String> pickImagePath(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();

    XFile? file = await imagePicker.pickImage(source: source);

    if (file != null) {
      return file.path;
    } else {
      print('No Image Selected');
      return "";
    }
  }
}

void changeRoute(BuildContext context, route) {
  Navigator.pushNamed(context, route);
}
