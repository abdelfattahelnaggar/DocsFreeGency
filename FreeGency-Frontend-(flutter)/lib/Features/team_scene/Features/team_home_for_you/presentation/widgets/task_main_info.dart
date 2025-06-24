import 'package:flutter/material.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/data/models/task_model.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';
import 'package:iconsax/iconsax.dart';

class TaskMainInfo extends StatelessWidget {
  final TaskModel task;
  const TaskMainInfo({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        16.height,
        ReusableTextStyleMethods.poppins24BoldMethod(
          context: context,
          text: task.title ?? "No Title",
        ),
        16.height,
        Row(
          children: [
            const Icon(
              Iconsax.clock4,
            ),
            8.width,
            Text(task.timeAgo, style: AppTextStyles.poppins12Regular(context)),
          ],
        ),
        16.height,
        Container(
          child: ReusableTextStyleMethods.poppins14RegularMethod(
              context: context, text: task.description ?? "No Description"),
        ),
      ],
    );
  }
}
