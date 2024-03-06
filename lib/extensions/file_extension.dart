import 'dart:convert';
import 'dart:io';

extension FileExtension on File? {
  double get extSizeInMB {
    if (this == null) {
      throw (Exception(
        'File Kosong',
      ));
    }
    int sizeInBytes = this!.lengthSync();
    double sizeInMb = sizeInBytes / (1024 * 1024);
    return sizeInMb;
  }

  double get sizeInKB {
    if (this == null) {
      throw (Exception(
        'File Kosong',
      ));
    }
    int sizeInBytes = this!.lengthSync();
    return sizeInBytes / (1000);
  }

  String extToBase64() {
    if (this == null) {
      return '';
      // throw (Exception(
      //   'File Kosong',
      // ));
    }
    List<int> imageBytes = this!.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    return base64Image;
  }
}
