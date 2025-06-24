import 'package:flutter/material.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/data/models/task_model.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/presentation/widgets/section_of_tasks_for_team.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';
import 'package:get/get.dart';

class BodyInSuccessState extends StatelessWidget {
  const BodyInSuccessState({
    super.key,
    required this.allTasks,
  });

  final List<TaskModel> allTasks;

  @override
  Widget build(BuildContext context) {
    // Filter tasks by status
    final inProgressTasks = allTasks
        .where((task) => task.status?.toLowerCase() == 'in-progress')
        .toList();

    final completedTasks = allTasks
        .where((task) => task.status?.toLowerCase() == 'completed')
        .toList();

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          24.height,
          ReusableTextStyleMethods.poppins24BoldMethod(
            context: context,
            text: 'Projects',
          ),
          8.height,
          ReusableTextStyleMethods.poppins16RegularMethod(
            context: context,
            text: 'Manage all projects details',
          ),
          16.height,
          SectionOfTasksForTeam(
            title: 'In Progress',
            tasks: inProgressTasks,
            color: context.theme.colorScheme.primary,
            emptyMessage: 'No tasks in progress',
          ),
          16.height,
          SectionOfTasksForTeam(
            title: 'Completed',
            tasks: completedTasks,
            color: context.theme.colorScheme.tertiary,
            emptyMessage: 'No completed tasks',
          ),
          16.height,
        ],
      ).paddingSymmetric(horizontal: 16),
    );
  }
}
