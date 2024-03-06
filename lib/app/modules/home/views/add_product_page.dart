import 'package:catalog_pharmacy_fe/app/modules/home/controllers/home_controller.dart';
import 'package:catalog_pharmacy_fe/app/modules/home/views/components/category_badge.dart';
import 'package:catalog_pharmacy_fe/app/modules/home/views/components/main_file_upload.dart';
import 'package:catalog_pharmacy_fe/themes/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AddProductPage extends StatelessWidget {
  const AddProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (c) {
      return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: AppColors.backgroundColor,
          appBar: AppBar(
            title: Text(
              'Add Product',
              style: GoogleFonts.quicksand(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
            ),
            backgroundColor: AppColors.backgroundColor,
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name',
                    style: GoogleFonts.quicksand(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ).marginOnly(bottom: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppColors.strokeColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: c.titleC,
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: 1,
                      onTapOutside: (event) {
                        FocusScope.of(context).unfocus();
                      },
                      style: const TextStyle(fontWeight: FontWeight.w500),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Price',
                    style: GoogleFonts.quicksand(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ).marginOnly(bottom: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppColors.strokeColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: c.priceC,
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: 1,
                      onTapOutside: (event) {
                        FocusScope.of(context).unfocus();
                      },
                      style: const TextStyle(fontWeight: FontWeight.w500),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Description',
                    style: GoogleFonts.quicksand(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ).marginOnly(bottom: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppColors.strokeColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: c.descriptionC,
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: 3,
                      onTapOutside: (event) {
                        FocusScope.of(context).unfocus();
                      },
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Text(
                        'Category : ',
                        style: GoogleFonts.quicksand(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (c.selectedCategory != null) ...[
                        CategoryBadge(
                          category: c.selectedCategory,
                          ontap: () {
                            c.selectedCategory = null;
                            c.update();
                          },
                        )
                      ],
                    ],
                  ),
                  if (c.selectedCategory == null) ...[
                    const SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      height: 25,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: c.categoriesList.length,
                        itemBuilder: (context, index) {
                          var category = c.categoriesList[index];
                          return InkWell(
                            onTap: () {
                              c.selectedCategory = category;
                              c.update();
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: CategoryBadge(
                                category: category,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                  const SizedBox(
                    height: 20,
                  ),
                  MainFileUpload(
                    title: 'Upload Image',
                    value: c.fileUploadResult,
                    isLimitationSize: true,
                    onChanged: (value) {
                      c.fileUploadResult = value;
                      c.update();
                    },
                  ),
                ],
              ),
            ),
          ),
          bottomSheet: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: AppColors.backgroundColor,
            child: ElevatedButton(
              onPressed: () {
                c.addProduct();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.purpleColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Add Product',
                style: GoogleFonts.quicksand(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ));
    });
  }
}
