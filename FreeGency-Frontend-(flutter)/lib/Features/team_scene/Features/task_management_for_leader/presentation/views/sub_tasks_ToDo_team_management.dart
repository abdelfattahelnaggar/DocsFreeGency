import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/data/model/sub_task_model.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/presentation/view_model/team_task_management_cubit.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/presentation/view_model/team_task_management_states.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/presentation/widgets/build_task_info.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/presentation/widgets/create_task_dialog.dart';
import 'package:freegency_gp/core/shared/widgets/app_loading_indicator.dart';
import 'package:freegency_gp/core/shared/widgets/call_to_action_button.dart';
import 'package:freegency_gp/core/shared/widgets/custom_app_bar.dart';
import 'package:freegency_gp/core/utils/helpers/custom_snackbar.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';

/// Screen for displaying and managing sub tasks for a specific task
///
/// This screen has been refactored to:
/// - Use SubTaskModel directly instead of passing individual parameters
/// - Utilize utility classes for common operations (CommentConverterUtil, DateFormatterUtil)
/// - Implement proper loading states and error handling
/// - Support real-time comment addition with API integration
class SubTasksToDoTeamManagement extends StatefulWidget {
  const SubTasksToDoTeamManagement({super.key, required this.taskId});

  final String taskId;

  @override
  State<SubTasksToDoTeamManagement> createState() =>
      _SubTasksToDoTeamManagementState();
}

class _SubTasksToDoTeamManagementState
    extends State<SubTasksToDoTeamManagement> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          TeamTaskManagementCubit()..getSubTasks(widget.taskId),
      child: Builder(
        builder: (context) {
          void showCreateTaskDialog(BuildContext context) {
            final cubit = context.read<TeamTaskManagementCubit>();
            showGeneralDialog(
              context: context,
              barrierLabel: "Create Task",
              barrierDismissible: true,
              barrierColor: Colors.black.withValues(alpha: 0.3),
              transitionDuration: const Duration(milliseconds: 200),
              pageBuilder: (context, animation, secondaryAnimation) {
                return BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Center(
                    child: BlocProvider.value(
                      value: cubit,
                      child: CreateTaskDialog(taskId: widget.taskId),
                    ),
                  ),
                );
              },
            );
          }

          return Scaffold(
            appBar: CustomAppBar(
              isHome: false,
              child: ReusableTextStyleMethods.poppins16BoldMethod(
                  context: context, text: 'Task Details'),
            ),
            body:
                BlocListener<TeamTaskManagementCubit, TeamTaskManagementState>(
              listener: (context, state) {
                if (state is AddCommentToSubTaskSuccess) {
                  CustomSnackbar.showSuccess(
                    title: 'Success',
                    message: state.message,
                  );
                  // No need to refresh - optimistic updates handle UI
                } else if (state is AddCommentToSubTaskError) {
                  CustomSnackbar.showError(
                    title: 'Error',
                    message: state.errorMessage,
                  );
                  // State already contains reverted data, UI will update automatically
                } else if (state is GetSubTasksError) {
                  CustomSnackbar.showError(
                    title: 'Error',
                    message: state.errorMessage,
                  );
                } else if (state is AssignTaskToMemberSuccess) {
                  // Show success message
                  CustomSnackbar.showSuccess(
                    title: 'Success',
                    message: state.message,
                  );
                  // Refresh sub tasks to show the new assigned task
                  context
                      .read<TeamTaskManagementCubit>()
                      .getSubTasks(widget.taskId);
                } else if (state is AssignTaskToMemberError) {
                  CustomSnackbar.showError(
                    title: 'Error',
                    message: state.errorMessage,
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          // Refresh sub tasks
                          context
                              .read<TeamTaskManagementCubit>()
                              .getSubTasks(widget.taskId);

                          // Wait for the refresh to complete
                          await Future.delayed(
                              const Duration(milliseconds: 500));
                        },
                        color: Theme.of(context).colorScheme.primary,
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        child: ListView(
                          children: [
                            16.height,
                            FutureBuilder(
                              future: context
                                  .read<TeamTaskManagementCubit>()
                                  .isCurrentUserTeamLeader(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData && snapshot.data == true) {
                                  return PrimaryCTAButton(
                                    label: 'Create Task',
                                    onTap: () {
                                      showCreateTaskDialog(context);
                                    },
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                    labelColor:
                                        Theme.of(context).colorScheme.onSurface,
                                    icon: Icons.add,
                                  );
                                }
                                return const SizedBox();
                              },
                            ),
                            16.height,
                            BlocBuilder<TeamTaskManagementCubit,
                                TeamTaskManagementState>(
                              builder: (context, state) {
                                // Handle different states
                                List<SubTaskModel> subTasksToDisplay = [];

                                if (state is GetSubTasksLoading) {
                                  return const Center(
                                      child: AppLoadingIndicator());
                                } else if (state is GetSubTasksSuccess) {
                                  subTasksToDisplay = state.subTasks;
                                } else if (state
                                    is SubTasksUpdatedWithComment) {
                                  // Handle optimistic updates
                                  subTasksToDisplay = state.subTasks;
                                } else if (state
                                    is AddCommentToSubTaskSuccess) {
                                  // Handle successful comment addition
                                  subTasksToDisplay = state.updatedSubTasks;
                                } else if (state is AddCommentToSubTaskError) {
                                  // Handle failed comment addition (reverted state)
                                  subTasksToDisplay = state.revertedSubTasks;
                                } else if (state is GetSubTasksError) {
                                  return Container(
                                    padding: const EdgeInsets.all(32),
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.error_outline,
                                          size: 48,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error,
                                        ),
                                        16.height,
                                        Text(
                                          'Failed to load sub tasks',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        ),
                                        8.height,
                                        Text(
                                          state.errorMessage,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                          textAlign: TextAlign.center,
                                        ),
                                        16.height,
                                        ElevatedButton(
                                          onPressed: () {
                                            context
                                                .read<TeamTaskManagementCubit>()
                                                .getSubTasks(widget.taskId);
                                          },
                                          child: const Text('Retry'),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  // Use cubit's current state if available
                                  final cubit =
                                      context.read<TeamTaskManagementCubit>();
                                  subTasksToDisplay = cubit.currentSubTasks;
                                }

                                // Display sub tasks
                                if (subTasksToDisplay.isEmpty) {
                                  return Container(
                                    padding: const EdgeInsets.all(32),
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.task_alt,
                                          size: 48,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .outline,
                                        ),
                                        16.height,
                                        Text(
                                          'No sub tasks available',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        ),
                                        8.height,
                                        Text(
                                          'Pull down to refresh or create a new task',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  );
                                }

                                return Column(
                                  children: subTasksToDisplay.map((subTask) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 16),
                                      child: BuildTaskInfo(
                                        subTask: subTask,
                                      ),
                                    );
                                  }).toList(),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
