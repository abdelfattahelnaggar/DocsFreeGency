import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/data/models/project_model.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/presentation/widgets/project_inspiration_view_image.dart';
import 'package:freegency_gp/core/utils/constants/routes.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ProjectInspirationViewCard extends StatelessWidget {
  const ProjectInspirationViewCard({
    super.key,
    required this.projectModel,
  });

  final ProjectModel projectModel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 183.w,
      height: 180.h,
      child: GestureDetector(
        onTap: () =>
            Get.toNamed(AppRoutes.projectInspiration, arguments: projectModel),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProjectInspirationViewImage(imageUrl: projectModel.imageCover),
            SizedBox(height: 5.h),
            Text(
              projectModel.title ?? 'No Title',
              style: AppTextStyles.poppins12Regular(context)!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 5.h),
            Row(
              children: [
                const Icon(
                  Iconsax.star1,
                  color: Colors.yellow,
                  size: 18,
                ),
                SizedBox(width: 8.w),
                Text(
                  projectModel.averageRating.toString(),
                  style: AppTextStyles.poppins12Regular(context)!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  '(${projectModel.ratingCount} ${context.tr('reviews')})',
                  style: AppTextStyles.poppins12Regular(context)!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 10.sp),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
