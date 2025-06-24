import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/data/models/task_model.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/presentation/widgets/tag_item.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class PostedTaskCard extends StatelessWidget {
  final TaskModel project;
  final VoidCallback onTap;
  final bool isTeam;

  const PostedTaskCard({
    super.key,
    required this.project,
    required this.onTap,
    this.isTeam = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Posted Time
          Text(project.timeAgo,
              style: TextStyle(
                fontSize: 8.sp,
                color: Theme.of(context).colorScheme.secondary,
              )).paddingSymmetric(horizontal: 16.w),
          8.height,
          // Title
          ReusableTextStyleMethods.poppins24BoldMethod(
            context: context,
            text: project.title ?? 'Untitled Task',
          ).paddingSymmetric(horizontal: 16.w),
          4.height,
          // Description
          Text(
            project.description ?? 'No description',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.poppins12Regular(context),
          ).paddingSymmetric(horizontal: 16.w),
          8.height,
          // Budget
          Text(
            'Budget: ${project.budget} USD',
            style: AppTextStyles.poppins12Regular(context)!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ).paddingSymmetric(horizontal: 16.w),
          8.height,
          // Tags
          SizedBox(
            height: 30.h,
            child: ListView.builder(
              padding: EdgeInsets.only(left: 16.w),
              scrollDirection: Axis.horizontal,
              itemCount: project.requiredSkills?.length ?? 0,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: TagItem(tag: project.requiredSkills?[index] ?? ''),
                );
              },
            ),
          ),
          8.height,
          // Actions and Status
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onTap,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ReusableTextStyleMethods.poppins12RegularMethod(
                            context: context, text: 'View Task'),
                        8.w.width,
                        Icon(
                          Iconsax.send_sqaure_2,
                          color: Theme.of(context).colorScheme.onSurface,
                          size: 16.sp,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (!isTeam)
                Expanded(
                  child: Text(
                    project.status ?? 'A1A',
                    style: AppTextStyles.poppins12Regular(context)!.copyWith(
                    color: Colors.green,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ).paddingSymmetric(horizontal: 16.w)
        ],
      ),
    );
  }
}
