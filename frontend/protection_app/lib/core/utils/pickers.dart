import 'package:file_picker/file_picker.dart';
import 'dart:io';



Future<File?> pickAudio() async {
  try {
    final filepicker = await FilePicker.platform.pickFiles(
      type: FileType.audio,

    );

    if (filepicker != null) {
      return File(filepicker.files.first.xFile.path);
    }
    return null;
  } catch (e) {
    return null;
  }
}




Future<File?> pickImage() async {
  try {
    final filepicker = await FilePicker.platform.pickFiles(
      type: FileType.image,
      
    );

    if (filepicker != null) {
      final selectedFile = File(filepicker.files.first.xFile.path);
      // Check if file exists and is readable
      if (await selectedFile.exists()) {
        return selectedFile;
      }
    }
    return null;
  } catch (e) {
    print('Image pick error: $e');
    return null;
  }
}
