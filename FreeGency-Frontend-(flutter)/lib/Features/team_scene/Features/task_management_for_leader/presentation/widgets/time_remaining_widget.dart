import 'package:flutter/material.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/data/models/task_model.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';
import 'package:iconsax/iconsax.dart';

class TimeRemainingWidget extends StatelessWidget {
  final TaskModel task;

  const TimeRemainingWidget({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    String timeText = '—';

    if (task.deadline != null) {
      final now = DateTime.now();
      final difference = task.deadline!.difference(now);

      if (difference.inDays > 0) {
        timeText = '${difference.inDays}d';
      } else if (difference.inHours > 0) {
        timeText = '${difference.inHours}h';
      } else if (difference.inMinutes > 0) {
        timeText = '${difference.inMinutes}m';
      } else {
        timeText = 'Overdue';
      }
    }

    return Row(
      children: [
        Icon(
          Iconsax.clock,
          size: 20,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        8.width,
        Text(
          timeText,
          style: AppTextStyles.poppins14Regular(context)!.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
