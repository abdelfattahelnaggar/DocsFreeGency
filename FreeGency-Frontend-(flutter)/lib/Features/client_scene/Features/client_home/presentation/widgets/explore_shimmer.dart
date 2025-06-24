import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freegency_gp/core/shared/widgets/shimmer_loading.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';
import 'package:get/get.dart';

class ExploreServicesShimmer extends StatelessWidget {
  const ExploreServicesShimmer({
    super.key,
    required this.color,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    final isRTL = context.locale.languageCode == 'ar';
    final theme = Theme.of(context);

    return ShimmerLoading(
      child: Container(
        padding: const EdgeInsets.all(16),
        width: Get.width * 0.75,
        height: 170.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          color: color.withValues(alpha: 0.5),
        ),
        child: Stack(
          children: [
            Positioned(
              right: isRTL ? null : 0,
              left: isRTL ? 0 : null,
              child: Container(
                width: 120.w,
                height: 140.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: theme.colorScheme.surface,
                ),
              ),
            ),
            Positioned(
              right: isRTL ? 0 : null,
              left: isRTL ? null : 0,
              child: SizedBox(
                width: Get.width * 0.4,
                child: Column(
                  crossAxisAlignment:
                      isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: Get.width * 0.35,
                      height: 30.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: theme.colorScheme.surface,
                      ),
                    ),
                    12.height,
                    Container(
                      width: Get.width * 0.25,
                      height: 16.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.r),
                        color: theme.colorScheme.surface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
