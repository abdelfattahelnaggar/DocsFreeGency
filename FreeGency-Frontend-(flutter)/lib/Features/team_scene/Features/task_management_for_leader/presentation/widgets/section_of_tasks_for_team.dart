import 'package:flutter/material.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/data/models/task_model.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/presentation/views/sub_tasks_ToDo_team_management.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/presentation/widgets/number_progress_projects_widget.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/presentation/widgets/project_task_card.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';
import 'package:get/get.dart';

class SectionOfTasksForTeam extends StatelessWidget {
  const SectionOfTasksForTeam({
    super.key,
    required this.title,
    required this.tasks,
    required this.color,
    required this.emptyMessage,
  });

  final String title;
  final List<TaskModel> tasks;
  final Color color;
  final String emptyMessage;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        color: context.theme.colorScheme.secondary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        spacing: 16,
        children: [
          TaskSectionHeaderWidget(
            title: title,
            taskCount: tasks.length,
            color: color,
          ),
          if (tasks.isEmpty)
            Container(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Icon(
                    title == 'Completed'
                        ? Icons.check_circle_outline
                        : Icons.task_alt,
                    size: 48,
                    color: context.theme.colorScheme.outline,
                  ),
                  16.height,
                  ReusableTextStyleMethods.poppins16RegularMethod(
                    context: context,
                    text: emptyMessage,
                  ),
                  8.height,
                  Text(
                    'Pull down to refresh',
                    style: context.theme.textTheme.bodySmall,
                  ),
                ],
              ),
            )
          else
            ...tasks.map(
              (task) => GestureDetector(
                onTap: () {
                  if (title == 'In Progress') {
                    Get.to(() => SubTasksToDoTeamManagement(taskId: task.id!));
                  }
                },
                child: ProjectTaskCard(task: task),
              ),
            ),
        ],
      ),
    );
  }
}
