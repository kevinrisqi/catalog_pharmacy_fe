import 'package:catalog_pharmacy_fe/themes/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


import 'package:get/get.dart';

class DialogService {
  static Future<dynamic> showGeneralDrawer({
    bool isDismissable = true,
    double radius = 12,
    bool withStrip = true,
    Color? color,
    Widget? content,
    EdgeInsets padding =
        const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  }) async {
    await Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: color ?? AppColors.backgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(radius),
              topRight: Radius.circular(radius),
            ),
          ),
          padding: padding,
          child: Column(
            children: [
              Container(
                width: 65,
                height: 5,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(2.5)),
                    color: withStrip
                        ? Colors.grey.withOpacity(0.5)
                        : Colors.transparent),
              ),
              SizedBox(
                height: 24,
              ),
              content ?? const SizedBox(),
            ],
          ),
        ),
      ),
      // context: Get.context!,
      isDismissible: isDismissable,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      // builder: (context) {
      //   return
      // },
    );
  }
}

enum MainPopupButtonDirection { Vertical, Horizontal }

enum ShowType { Drawer, Popup }

enum VerificationType {
  CompleteProfile,
  VerifyKtp,
  VerifyEmail,
}
