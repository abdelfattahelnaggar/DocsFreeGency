
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/presentation/widgets/project_shimmer_card.dart';

class GridViewLoading extends StatelessWidget {
  const GridViewLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8.h,
        crossAxisSpacing: 16.w,
        childAspectRatio: 0.98,
      ),
      itemCount: 4, // Show 4 shimmer items
      itemBuilder: (context, index) => const ProjectsShimmer(),
    );
  }
}