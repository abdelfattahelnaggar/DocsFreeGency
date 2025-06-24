import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';
import 'package:iconsax/iconsax.dart';

class ProjectInspirationViewImage extends StatelessWidget {
  const ProjectInspirationViewImage({
    super.key,
    required this.imageUrl,
  });

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    // Safely determine if we have a valid image URL
    final bool hasValidImageUrl = imageUrl != null && imageUrl!.isNotEmpty;
    const String fallbackImageUrl =
        'https://5.imimg.com/data5/SELLER/Default/2022/11/NH/NG/WB/8226049/project-management-software-500x500.jpg';

    return Container(
      width: 183.w,
      height: 130.h,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(12.r),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: hasValidImageUrl ? imageUrl! : fallbackImageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) =>
                const Center(child: Icon(Icons.error)),
          ),
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: const Color(0xff0051FF).withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Iconsax.link,
                    color: Color(0xff0051FF),
                    size: 18,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'Open',
                    style: AppTextStyles.poppins12Regular(context)!
                        .copyWith(color: const Color(0xff0051FF)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
