import 'package:catalog_pharmacy_fe/themes/app_colors.dart';
import 'package:flutter/material.dart';

class CategoryBadge extends StatelessWidget {
  const CategoryBadge({this.category, this.ontap, super.key});

  final String? category;
  final VoidCallback? ontap;

  @override
  Widget build(BuildContext context) {
    ColorModel color;

    if (category == "vitamin") {
      color = ColorModel(
          backgroundColor: AppColors.purpleAccentColor,
          textColor: AppColors.purpleColor);
    } else if (category == "medicine") {
      color =
          ColorModel(backgroundColor: AppColors.greenAccentColor, textColor: AppColors.greenColor);
    } else if (category == "cleanser") {
      color = ColorModel(backgroundColor: AppColors.redAccentColor, textColor: AppColors.redColor);
    } else {
      color = ColorModel(
          backgroundColor: AppColors.yellowAccentColor, textColor: AppColors.yellowColor);
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal:8, vertical:4),
      decoration: BoxDecoration(
        color: color.backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: ontap,
        child: Row(
          children: [
            Text(category ?? '',
                style: TextStyle(
                  color: color.textColor,
                  fontSize: 12,
                )),
            if (ontap != null) ...[
              const SizedBox(
                width: 8,
              ),
              Icon(
                Icons.close,
                size: 10,
                color: color.textColor,
              ),
            ]
          ],
        ),
      ),
    );
  }
}

// class CategoryCountBadge extends StatelessWidget {
//   const CategoryCountBadge(
//       {this.category, this.ontap, this.count = "0", super.key});

//   final String? category;
//   final String? count;
//   final VoidCallback? ontap;

//   @override
//   Widget build(BuildContext context) {
//     ColorModel color;

//     if (category == "personal") {
//       color = ColorModel(
//           backgroundColor: AppColors.purpleAccentColor,
//           textColor: AppColors.purpleColor);
//     } else if (category == "work") {
//       color = ColorModel(
//           backgroundColor: AppColors.greenAccentColor,
//           textColor: AppColors.greenColor);
//     } else if (category == "love") {
//       color = ColorModel(
//           backgroundColor: AppColors.redAccentColor,
//           textColor: AppColors.redColor);
//     } else {
//       color = ColorModel(
//           backgroundColor: AppColors.yellowAccentColor,
//           textColor: AppColors.yellowColor);
//     }
//     return Row(
//       children: [
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//           decoration: BoxDecoration(
//             color: color.backgroundColor,
//             borderRadius:
//                 const BorderRadius.horizontal(left: Radius.circular(8)),
//           ),
//           child: InkWell(
//             onTap: ontap,
//             child: Row(
//               children: [
//                 Text(category ?? '',
//                     style: TextStyle(
//                       color: color.textColor,
//                       fontSize: 12,
//                     )),
//                 if (ontap != null) ...[
//                   const SizedBox(
//                     width: 8,
//                   ),
//                   Icon(
//                     Icons.close,
//                     size: 10,
//                     color: color.textColor,
//                   ),
//                 ]
//               ],
//             ),
//           ),
//         ),
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//           decoration: BoxDecoration(
//               color: Colors.white,
//               border: Border.all(color: color.backgroundColor)),
//           child: Text(
//             count ?? '0',
//             style: const TextStyle(
//               color: Colors.black,
//               fontSize: 12,
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }

class ColorModel {
  Color backgroundColor;
  Color textColor;

  ColorModel({
    required this.backgroundColor,
    required this.textColor,
  });
}
