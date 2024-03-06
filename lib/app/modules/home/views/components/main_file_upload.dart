import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:catalog_pharmacy_fe/extensions/file_extension.dart';
import 'package:catalog_pharmacy_fe/themes/app_colors.dart';
import 'package:catalog_pharmacy_fe/utils/dialog_service.dart';
import 'package:catalog_pharmacy_fe/utils/file_compress.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class MainFileUpload extends StatefulWidget {
  final String title;
  final FileUploadResult value;
  final Function(FileUploadResult)? onChanged;
  final bool readOnly;
  final bool isLimitationSize;
  final String hint;
  final int maxSize;

  const MainFileUpload({
    super.key,
    required this.title,
    required this.value,
    this.readOnly = false,
    this.isLimitationSize = false,
    this.onChanged,
    this.hint = 'Format file .jpeg, .jpg dan .png',
    this.maxSize = 512,
  });

  @override
  MainFileUploadState createState() => MainFileUploadState();
}

class MainFileUploadState extends State<MainFileUpload> {
  var fileName = ''.obs;

  @override
  void initState() {
    super.initState();

    fileName.value = widget.value.fileName ?? '';
  }

  Future<FileUploadResult?> getImage(
      {ImageSource source = ImageSource.gallery}) async {
    ImagePicker imagePicker = ImagePicker();

    final pickedFile = await imagePicker.pickImage(source: source);

    if (pickedFile != null) {
      fileName.value = "Memproses file ...";

      if ((pickedFile.path.toLowerCase().endsWith('.heic') ||
              pickedFile.path.toLowerCase().endsWith('.heif')) ||
          pickedFile.path.toLowerCase().endsWith('.svg')) {
        Get.snackbar('Gagal Upload File', 'Format file gambar tidak diterima');
        fileName.value = '';
        return null;
      }

      if (widget.isLimitationSize == true) {
        File selectedImage = File(pickedFile.path);

        var imageSize = selectedImage.sizeInKB;

        if (imageSize <= (widget.maxSize + 24).toDouble()) {
          fileName.value = selectedImage.path.split('/').last;

          return FileUploadResult(
            fileName: fileName.value,
            base64Value: base64Encode(
              selectedImage.readAsBytesSync(),
            ),
          );
        } else {
          Get.snackbar('Gagal', 'Ukuran file gambar terlalu besar');

          fileName.value = '';
          return null;
        }
      }

      var img = await CompressionUtils.compressToMaxSize(
          File(pickedFile.path), widget.maxSize * 1000);

      fileName.value = pickedFile.path.split('/').last;

      return FileUploadResult(
          fileName: fileName.value, base64Value: base64Encode(img));
    } else {
      fileName.value = '';
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.title,
                style: GoogleFonts.quicksand(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                )),
            widget.readOnly
                ? const SizedBox()
                : InkWell(
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      DialogService.showGeneralDrawer(
                          content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Card(
                            child: InkWell(
                              onTap: () async {
                                Get.back();
                                var result = await getImage();
                                if (result != null) {
                                  widget.onChanged!(result);
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    const Icon(Icons.image),
                                    Text(
                                      "Galeri",
                                      style: GoogleFonts.quicksand(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Card(
                            child: InkWell(
                              onTap: () async {
                                Get.back();
                                var result =
                                    await getImage(source: ImageSource.camera);
                                if (result != null) {
                                  widget.onChanged!(result);
                                }
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Icon(Icons.camera_alt),
                                    Text(
                                      "Kamera",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ));
                    },
                    child: Obx(
                      () => Text(
                        fileName.value.isNotEmpty ? "Ganti" : "Unggah",
                        style: GoogleFonts.quicksand(
                          color: fileName.value.isNotEmpty
                              ? AppColors.primaryColor
                              : Colors.blue,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
          ],
        ),
        const SizedBox(
          height: 12,
        ),
        Obx(
          () => fileName.value.isNotEmpty
              ? Row(
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                      size: 38,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            (fileName.value == "Memproses file ...")
                                ? fileName.value
                                : widget.value.fileName ?? '',
                            style: GoogleFonts.quicksand(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Container(
                            height: 3,
                            color: Colors.green,
                          )
                        ],
                      ),
                    )
                  ],
                )
              : Text(
                  // "Maks. file 50KB. Format file .jpeg, .jpg dan .png",
                  // "Format file .jpeg, .jpg dan .png\nGunakan latar belakang biru, dan resolusi 480x640 pixel",
                  widget.hint,
                  style:
                      GoogleFonts.quicksand(fontSize: 12, color: Colors.grey),
                ),
        ),
      ],
    );
  }
}

class FileUploadResult {
  final String? fileName;
  final String? base64Value;

  FileUploadResult({this.fileName, this.base64Value});

  Map<String, dynamic> toJson() {
    return {
      "fileName": fileName,
      "base64Value": base64Value,
    };
  }

  static FileUploadResult fromJson(Map<String, dynamic> json) {
    return FileUploadResult(
      fileName: json["fileName"],
      base64Value: json["base64Value"],
    );
  }
}
