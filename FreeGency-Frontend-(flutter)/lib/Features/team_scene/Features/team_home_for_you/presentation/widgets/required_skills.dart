import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/data/models/task_model.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/presentation/widgets/tag_item.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';

class RequiredSkills extends StatelessWidget {
  final TaskModel task;
  const RequiredSkills({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ReusableTextStyleMethods.poppins14BoldMethod(
          context: context,
          text: "Required skills :",
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: List.generate(
            task.requiredSkills?.length ?? 0,
            (index) => SizedBox(
              child: Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: TagItem(tag: task.requiredSkills?[index] ?? ''),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
