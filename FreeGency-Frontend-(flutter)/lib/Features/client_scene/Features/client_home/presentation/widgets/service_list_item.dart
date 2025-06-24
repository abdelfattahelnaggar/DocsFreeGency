import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';
import 'package:iconsax/iconsax.dart';

class ServiceListItem extends StatelessWidget {
  final String text;
  final String image;
  final VoidCallback onTap;

  const ServiceListItem({
    super.key,
    required this.text,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 75.h,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(24),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: CachedNetworkImage(
                imageUrl: image,
                width: 55.w,
                height: 55.h,
                fit: BoxFit.cover,
              ),
            ),
            16.width,
            ReusableTextStyleMethods.poppins16RegularMethod(
              context: context,
              text: text,
            ),
            const Spacer(),
            Icon(
              Iconsax.info_circle,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ],
        ),
      ),
    );
  }
}
