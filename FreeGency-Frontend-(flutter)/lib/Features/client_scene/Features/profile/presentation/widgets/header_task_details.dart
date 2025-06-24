import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/data/models/task_model.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/presentation/widgets/tag_item.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';

class HeaderTaskDetailsContainer extends StatelessWidget {
  const HeaderTaskDetailsContainer({
    super.key,
    required this.task,
  });

  final TaskModel task;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppBarTheme.of(context).backgroundColor,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReusableTextStyleMethods.poppins24BoldMethod(
            context: context,
            text: task.title ?? context.tr('no_title'),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 16.sp,
                color: Theme.of(context).colorScheme.secondary,
              ),
              SizedBox(width: 4.w),
              ReusableTextStyleMethods.poppins12RegularMethod(
                context: context,
                text: task.timeAgo,
              )
            ],
          ),
          SizedBox(height: 10.h),
          ReusableTextStyleMethods.poppins14RegularMethod(
            context: context,
            text: task.description ?? context.tr('no_description'),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.attach_money,
                    size: 24.sp,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  SizedBox(width: 4.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ReusableTextStyleMethods.poppins14RegularMethod(
                        context: context,
                        text: '${task.budget} USD',
                      ),
                      ReusableTextStyleMethods.poppins12RegularMethod(
                        context: context,
                        text: task.getLocalizedPriceType(context),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.category,
                    size: 24.sp,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  SizedBox(width: 4.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ReusableTextStyleMethods.poppins14RegularMethod(
                        context: context,
                        text: context.tr('project_type'),
                      ),
                      ReusableTextStyleMethods.poppins12RegularMethod(
                        context: context,
                        text: task.category ?? context.tr('no_category'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              ReusableTextStyleMethods.poppins14RegularMethod(
                context: context,
                text: '${context.tr('skills')}:',
              ),
              Expanded(
                child: SizedBox(
                  height: 35.h, // Give fixed height to ListView
                  child: ListView.builder(
                    padding: EdgeInsets.only(left: 16.w),
                    scrollDirection: Axis.horizontal,
                    itemCount: task.requiredSkills?.length ?? 0,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: TagItem(tag: task.requiredSkills?[index] ?? ''),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
