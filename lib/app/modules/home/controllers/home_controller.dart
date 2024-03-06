import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:catalog_pharmacy_fe/app/modules/home/views/components/main_file_upload.dart';
import 'package:catalog_pharmacy_fe/app/modules/home/views/home_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController with GetSingleTickerProviderStateMixin{
  final titleC = TextEditingController();
  final descriptionC = TextEditingController();
  final priceC = TextEditingController();

  final searchProductC = TextEditingController();

  final searchQuery = ''.obs;

  String? selectedCategory;

  String selectedFilterCategory = '';

  late TabController tabController;

  FileUploadResult fileUploadResult = FileUploadResult();

  List<String> categoriesList = [
    "vitamin",
    "medicine",
    "cleanser",
    "other",
  ];

  ///* Get Data From Firestore
  final CollectionReference productCollection =
      FirebaseFirestore.instance.collection('product');
  Stream<QuerySnapshot> get products => productCollection.snapshots();

  List<Product> listProduct = [];

  bool isLoading = false;

  List<Product> get product {
    // if (searchQuery.value.isEmpty) {
    //   return listProduct;
    // } else {
    //   return listProduct
    //       .where((element) => element.name!
    //           .toLowerCase()
    //           .contains(searchQuery.value.toLowerCase()))
    //       .toList();
    // }
    if (searchQuery.value.isNotEmpty){
      return listProduct
          .where((element) => element.name!
          .toLowerCase()
          .contains(searchQuery.value.toLowerCase()))
          .toList();
    }

    if (selectedFilterCategory.isNotEmpty) {
      return listProduct
          .where((element) => element.category!
          .toLowerCase()
          .contains(selectedFilterCategory.toLowerCase()))
          .toList();
    }

    return listProduct;
  }

  Future<void> getProduct() async {
    try {
      isLoading = true;
      var result = FirebaseFirestore.instance
          .collection('product')
          .orderBy('created_at', descending: true)
          .snapshots();

      result.listen((snapshot) {
        var items = snapshot.docs.map((e) {
          var data = e.data();
          return Product.fromJson(data, e.id);
        }).toList();

        log('Product Length: ${items.length}');
        if (items.isEmpty) {
          listProduct = [];
          isLoading = false;
        } else {
          listProduct = items;
          isLoading = false;
        }
        update();
      });
    } catch (e) {
      // Handle error
    }
  }

  /// * Handle for Upload Iamge to Firebase Storage
  Future<String> uploadImage(FileUploadResult result) async {
    String imageName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref =
        FirebaseStorage.instance.ref().child('/product/$imageName.jpg');

    log('message');

    log('Filename: ${result.fileName}');
    print('Base64: data:text/plain;base64, ${result.base64Value!}');

    var base64String = 'data:text/plain;base64,${result.base64Value!}';

    print('New Base64: $base64String');

    UploadTask uploadTask =
        ref.putString(base64String, format: PutStringFormat.dataUrl);

    uploadTask.snapshotEvents.listen((event) {
      // progressValue.value = (event.bytesTransferred / event.totalBytes) * 100;
      log('Bytes Transfered: ${event.bytesTransferred}');
      log('Total Bytes: ${event.totalBytes}');
      // log('Progress Upload: ${progressValue.value}');
    });

    TaskSnapshot taskSnapshot = await uploadTask;
    String imageUrl = await taskSnapshot.ref.getDownloadURL();
    return imageUrl;
  }

  void addProduct() async {
    var imageUrl = await uploadImage(fileUploadResult);

    productCollection.add({
      'name': titleC.text,
      'description': descriptionC.text,
      'price': int.parse(priceC.text),
      'category': selectedCategory,
      'image': imageUrl,
      'created_at': DateTime.now(),
      'updated_at': DateTime.now(),
    }).then((value) {
      clearInput();
      Get.back();
      Get.snackbar('Success', 'Product Added Successfully',
          colorText: Colors.white, backgroundColor: Colors.green);
    });
  }

  void clearInput() {
    titleC.clear();
    descriptionC.clear();
    priceC.clear();
    selectedCategory = null;
    fileUploadResult = FileUploadResult();
  }

  @override
  void onInit() {
    tabController = TabController(length: 4, vsync: this);

    getProduct();
    debounce(searchQuery, (callback) => product);
    super.onInit();
  }
}
