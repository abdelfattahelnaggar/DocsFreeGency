
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/presentation/widgets/grid_view_loading.dart';
import 'package:freegency_gp/core/shared/widgets/shimmer_loading.dart';

class TeamDetailsShimmer extends StatelessWidget {
  const TeamDetailsShimmer({
    super.key,
    required this.theme,
  });

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner shimmer
          ShimmerLoading(
            child: Container(
              width: double.infinity,
              height: 180.h,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
    
          SizedBox(height: 24.h),
    
          // Rating shimmer
          ShimmerLoading(
            child: Row(
              children: [
                Container(
                  width: 16.w,
                  height: 16.h,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  width: 120.w,
                  height: 16.h,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ],
            ),
          ),
    
          SizedBox(height: 24.h),
    
          // Projects heading shimmer
          ShimmerLoading(
            child: Container(
              width: 200.w,
              height: 48.h,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
    
          SizedBox(height: 24.h),
    
          // About Us heading shimmer
          ShimmerLoading(
            child: Container(
              width: 100.w,
              height: 24.h,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
    
          SizedBox(height: 8.h),
    
          // Description shimmer - 3 lines
          ShimmerLoading(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 16.h,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                SizedBox(height: 4.h),
                Container(
                  width: double.infinity,
                  height: 16.h,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                SizedBox(height: 4.h),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 16.h,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ],
            ),
          ),
    
          SizedBox(height: 24.h),
    
          // Skills shimmer
          ShimmerLoading(
            child: Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: List.generate(
                5,
                (index) => Container(
                  width: 80.w,
                  height: 32.h,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
              ),
            ),
          ),
    
          SizedBox(height: 24.h),
    
          // Projects heading shimmer
          ShimmerLoading(
            child: Container(
              width: 100.w,
              height: 24.h,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
    
          SizedBox(height: 16.h),
    
          // Projects grid shimmer
          const GridViewLoading(),
        ],
      ),
    );
  }
}