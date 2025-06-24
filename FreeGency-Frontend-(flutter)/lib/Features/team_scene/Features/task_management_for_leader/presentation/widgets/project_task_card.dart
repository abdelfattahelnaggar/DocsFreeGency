import 'package:flutter/material.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/data/models/task_model.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/presentation/widgets/action_buttons_section.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/presentation/widgets/assigned_to_section.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/presentation/widgets/project_info_section.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/presentation/widgets/project_type_chip.dart';
import 'package:get/get.dart';

class ProjectTaskCard extends StatelessWidget {
  final TaskModel task;
  
  const ProjectTaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          ProjectTypeChip(task: task),
          const SizedBox(),
          ProjectInfoSection(task: task),
          const SizedBox(),
          AssignedToSection(task: task),
          Divider(
            color: context.theme.colorScheme.secondary,
            thickness: 0.5,
            height: 5,
          ),
          ActionButtonsSection(task: task),
        ],
      ),
    );
  }
}
