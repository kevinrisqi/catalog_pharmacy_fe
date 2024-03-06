import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:catalog_pharmacy_fe/app/modules/home/views/add_product_page.dart';
import 'package:catalog_pharmacy_fe/themes/app_colors.dart';
import 'package:catalog_pharmacy_fe/utils/dialog_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/home_controller.dart';
import 'package:intl/intl.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(HomeController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Catalog Product',
          style: TextStyle(
            color: AppColors.primaryColor,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        leading: Icon(
          Icons.home,
          color: AppColors.primaryColor,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          !kIsWeb
              ? IconButton(
                  onPressed: () {
                    Get.to(const AddProductPage());
                  },
                  icon: Icon(
                    Icons.person,
                    color: AppColors.primaryColor,
                  ),
                )
              : const SizedBox()
        ],
      ),
      body: GetBuilder<HomeController>(builder: (context) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: controller.searchProductC,
                onChanged: (value) {
                  controller.searchQuery.value = value;
                  controller.update();
                },
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  suffixIcon: InkWell(
                    onTap: () {
                      controller.searchProductC.clear();
                      controller.searchQuery.value = '';
                      controller.update();
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  suffixIconConstraints: const BoxConstraints(
                    minWidth: 22,
                    minHeight: 16,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
              child: TabBar(
                controller: controller.tabController,
                indicatorColor: AppColors.primaryColor,
                labelColor: AppColors.primaryColor,
                unselectedLabelColor: Colors.grey,
                unselectedLabelStyle: controller.tabController.index == 1
                    ? GoogleFonts.quicksand(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      )
                    : GoogleFonts.quicksand(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                onTap: (value) {
                  switch (value) {
                    case 0:
                      controller.selectedFilterCategory = '';
                      break;
                    case 1:
                      controller.selectedFilterCategory = 'medicine';
                      break;
                    case 2:
                      controller.selectedFilterCategory = 'vitamin';
                      break;
                    case 3:
                      controller.selectedFilterCategory = 'supplement';
                      break;
                    default:
                  }
                  controller.update();
                },
                tabs: const [
                  Tab(
                    text: 'All',
                  ),
                  Tab(
                    text: 'Medicine',
                  ),
                  Tab(
                    text: 'Vitamin',
                  ),
                  Tab(
                    text: 'Supplement',
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.70,
                ),
                itemCount: controller.product.length,
                itemBuilder: (context, index) {
                  var item = controller.product[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (item.imageUrl != null)
                          Center(
                            child: Container(
                              margin: const EdgeInsets.only(top: 12),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(200),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(200),
                                child: CachedNetworkImage(
                                  width: 85,
                                  height: 85,
                                  imageUrl: item.imageUrl!,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  },
                                  errorWidget: (context, url, error) {
                                    return const Icon(Icons.error);
                                  },
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(
                          height: 12,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name ?? '-',
                                style: GoogleFonts.quicksand(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                item.category ?? '-',
                                style: GoogleFonts.quicksand(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  Text(
                                    NumberFormat.currency(
                                            locale: 'id_ID',
                                            decimalDigits: 0,
                                            symbol: 'Rp. ')
                                        .format(item.price),
                                    style: GoogleFonts.quicksand(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const Spacer(),
                                  InkWell(
                                    onTap: () {
                                      DialogService.showGeneralDrawer(
                                        color: Colors.white,
                                        content: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(Icons.close),
                                                  const SizedBox(
                                                    width: 12,
                                                  ),
                                                  Text(
                                                    'Detail Product',
                                                    style:
                                                        GoogleFonts.quicksand(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 24,
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    child: CachedNetworkImage(
                                                      imageUrl: item.imageUrl!,
                                                      width: 75,
                                                      height: 75,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 8,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        item.name ?? '',
                                                        style: GoogleFonts
                                                            .quicksand(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Category: ${item.category}',
                                                        style: GoogleFonts
                                                            .quicksand(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 8,
                                                      ),
                                                      Text(
                                                        NumberFormat.currency(
                                                                locale: 'id_ID',
                                                                decimalDigits:
                                                                    0,
                                                                symbol: 'Rp. ')
                                                            .format(item.price),
                                                        style: GoogleFonts
                                                            .quicksand(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              const Divider(),
                                              Text(item.description ?? ''),
                                              const SizedBox(
                                                height: 24,
                                              ),
                                              SizedBox(
                                                width: double.infinity,
                                                height: 45,
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                                    Get.back();

                                                    try {
                                                      /// * Send message to whatsapp
                                                      await launch(
                                                          'https://wa.me/6287777063035?text=I%20want%20to%20order%20${item.name}');
                                                    } catch (e) {
                                                      rethrow;
                                                    }
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        AppColors.primaryColor,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                  ),
                                                  child:
                                                      const Text('Order Now'),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      width: 35,
                                      height: 35,
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.add_shopping_cart,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}

class Product {
  final String? id;
  final String? name;
  final String? description;
  final int? price;
  final String? imageUrl;
  final String? category;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Product({
    this.name,
    this.description,
    this.price,
    this.imageUrl,
    this.category,
    this.id,
    this.createdAt,
    this.updatedAt,
  });

  /// * Factor from snapshot firestore
  /// * Convert snapshot to model
  factory Product.fromSnapshot(QueryDocumentSnapshot snapshot) {
    return Product(
      name: snapshot.get('name'),
      description: snapshot.get('description'),
      price: snapshot.get('price'),
      imageUrl: snapshot.get('image'),
      category: snapshot.get('category'),
    );
  }

  factory Product.fromJson(Map<String, dynamic> json, id) {
    Timestamp createdAtTimestamp = json['created_at'];
    Timestamp updatedAtTimestamp = json['updated_at'];

    return Product(
      id: id,
      name: json['name'],
      description: json['description'],
      price: json['price'],
      category: json['category'],
      imageUrl: json['image'] ?? "",
      createdAt: createdAtTimestamp.toDate(),
      updatedAt: updatedAtTimestamp.toDate(),
    );
  }
}
