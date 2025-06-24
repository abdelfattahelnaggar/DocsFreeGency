import 'package:flutter/material.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/data/models/task_model.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';

class ProjectInfoSection extends StatelessWidget {
  final TaskModel task;

  const ProjectInfoSection({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ReusableTextStyleMethods.poppins16BoldMethod(
          context: context,
          text: task.title ?? 'Untitled Task',
        ),
        Text(
          task.description ?? 'No description available',
          style: AppTextStyles.poppins14Regular(context),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
