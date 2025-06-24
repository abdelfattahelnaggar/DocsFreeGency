import 'package:flutter/material.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/data/models/task_model.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';
import 'package:get/get.dart';

class ProjectTypeChip extends StatelessWidget {
  final TaskModel task;

  const ProjectTypeChip({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: context.theme.colorScheme.primary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: context.theme.colorScheme.primary,
        ),
      ),
      child: Text(
        task.service ?? task.category ?? 'General',
        style: AppTextStyles.poppins12Regular(context)!.copyWith(
          color: context.theme.colorScheme.primary,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
