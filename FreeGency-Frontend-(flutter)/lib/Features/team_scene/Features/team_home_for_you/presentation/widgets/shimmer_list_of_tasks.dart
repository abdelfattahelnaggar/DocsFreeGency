import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerListOfTasks extends StatelessWidget {
  const ShimmerListOfTasks({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(18.r),
          ),
          child: Shimmer.fromColors(
            baseColor:
                Theme.of(context).colorScheme.secondary.withValues(alpha: 0.3),
            highlightColor:
                Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Posted Time shimmer
                Container(
                  width: 60.w,
                  height: 8.h,
                  color: Colors.white,
                ).paddingSymmetric(horizontal: 16.w),
                8.height,
                // Title shimmer
                Container(
                  width: 200.w,
                  height: 24.h,
                  color: Colors.white,
                ).paddingSymmetric(horizontal: 16.w),
                4.height,
                // Description shimmer
                Container(
                  width: double.infinity,
                  height: 12.h,
                  color: Colors.white,
                ).paddingSymmetric(horizontal: 16.w),
                4.height,
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 12.h,
                  color: Colors.white,
                ).paddingSymmetric(horizontal: 16.w),
                8.height,
                // Budget shimmer
                Container(
                  width: 120.w,
                  height: 12.h,
                  color: Colors.white,
                ).paddingSymmetric(horizontal: 16.w),
                8.height,
                // Tags shimmer
                Row(
                  children: List.generate(
                    3,
                    (index) => Container(
                      width: 80.w,
                      height: 30.h,
                      margin: EdgeInsets.only(right: 8.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                    ),
                  ),
                ).paddingOnly(left: 16.w),
                8.height,
                // Action and Status shimmer
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 36.h,
                        color: Colors.white,
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Container(
                          width: 60.w,
                          height: 12.h,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ).paddingSymmetric(horizontal: 16.w)
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => 16.height,
    );
  }
}
