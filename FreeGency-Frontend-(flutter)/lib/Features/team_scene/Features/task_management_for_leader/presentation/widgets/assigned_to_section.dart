import 'package:flutter/material.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/data/models/task_model.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/presentation/widgets/team_avatars_widget.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';

class AssignedToSection extends StatelessWidget {
  final TaskModel task;

  const AssignedToSection({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Assigned to',
          style: AppTextStyles.poppins14Regular(context)!.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(),
        TeamAvatarsWidget(task: task),
      ],
    );
  }
}
