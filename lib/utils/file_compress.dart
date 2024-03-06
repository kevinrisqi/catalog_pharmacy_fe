import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';



class CompressionUtils {
  static Future<Uint8List> compressToMaxSize(File file, int maxSize) async {
    int compareLength = file.lengthSync();

    int quality = 100;

    Uint8List result = file.readAsBytesSync();

    bool canLoop = true;

    //check length
    if (compareLength <= maxSize) {
      canLoop = false;
    }

    while (canLoop) {
      //change quality decrease to 1 when quality below 11
      if (quality <= 10) {
        quality--;
      } else {
        quality = quality - 10;
      }

      if (quality < 0) {
        quality = 0;
        canLoop = false;
      }
      result = (await FlutterImageCompress.compressWithFile(
        file.absolute.path,
        quality: quality,
      ))!;
      compareLength = result.length;

      //check length
      if (compareLength <= maxSize) {
        canLoop = false;
      }
    }

    log("original file size : ${file.lengthSync()}");
    log("compressed file size : ${result.length}");
    log("compressed file size in Kb: ${result.length / 1024}");
    return result;
  }
}
