import 'package:flutter/material.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';
import 'package:get/get.dart';

class TaskSectionHeaderWidget extends StatelessWidget {
  const TaskSectionHeaderWidget({
    super.key,
    required this.title,
    required this.taskCount,
    this.color,
  });

  final String title;
  final int taskCount;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
          decoration: BoxDecoration(
            color: color ?? context.theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        8.width,
        ReusableTextStyleMethods.poppins20BoldMethod(
          context: context,
          text: title,
        ),
        8.width,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: context.theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ReusableTextStyleMethods.poppins16BoldMethod(
            context: context,
            text: '$taskCount',
          ),
        )
      ],
    );
  }
}

// Keep the old widget for backward compatibility
class NumberOfProgressProjectsWidget extends StatelessWidget {
  const NumberOfProgressProjectsWidget({
    super.key,
    required this.numberOfInProgressTasks,
  });

  final int numberOfInProgressTasks;

  @override
  Widget build(BuildContext context) {
    return TaskSectionHeaderWidget(
      title: 'In Progress',
      taskCount: numberOfInProgressTasks,
    );
  }
}
