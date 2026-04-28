import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> pickimage() async {


  try { 
    final xfile = await ImagePicker().pickImage(
        source: ImageSource.gallery);
    if (xfile == null) return null;
    return File(xfile.path);
  } catch (e) {
    debugPrint('pickImage error: $e');  // don’t swallow it silently
    return null;
  }
}