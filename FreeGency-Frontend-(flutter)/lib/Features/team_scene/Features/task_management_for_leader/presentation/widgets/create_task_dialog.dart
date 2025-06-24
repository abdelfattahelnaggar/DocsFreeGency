import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/client_scene/Features/post_task/presentation/widgets/date_input_textfield.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/data/model/assign_task_to_member_model.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/data/model/team_member_model.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/presentation/view_model/team_task_management_cubit.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/presentation/view_model/team_task_management_states.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/presentation/widgets/custom_tast_text.dart';
import 'package:freegency_gp/core/utils/helpers/custom_snackbar.dart';

class CreateTaskDialog extends StatefulWidget {
  const CreateTaskDialog({super.key, required this.taskId});

  final String taskId;

  @override
  State<CreateTaskDialog> createState() => _CreateTaskDialogState();
}

class _CreateTaskDialogState extends State<CreateTaskDialog> {
  final TextEditingController taskTitleController = TextEditingController();
  final TextEditingController taskDesController = TextEditingController();
  final TextEditingController taskDeadLineController = TextEditingController();

  List<TeamMemberModel> teamMembers = [];
  TeamMemberModel? selectedMember;
  int descLength = 0;

  @override
  void initState() {
    super.initState();
    taskDesController.addListener(() {
      setState(() {
        descLength = taskDesController.text.length;
      });
    });
    // Fetch team members when dialog opens
    context.read<TeamTaskManagementCubit>().getTeamMembers();
  }

  @override
  void dispose() {
    taskTitleController.dispose();
    taskDesController.dispose();
    taskDeadLineController.dispose();
    super.dispose();
  }

  void _handleAssignTask() {
    if (taskTitleController.text.isEmpty ||
        taskDesController.text.isEmpty ||
        selectedMember == null ||
        taskDeadLineController.text.isEmpty) {
      CustomSnackbar.showError(
        title: 'assign_task.error'.tr(),
        message: 'assign_task.validation_error'.tr(),
      );
      return;
    }

    // Parse the date from the formatted string (YYYY/MM/DD)
    DateTime? deadline;
    try {
      final parts = taskDeadLineController.text.split('/');
      if (parts.length == 3) {
        final year = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final day = int.parse(parts[2]);
        deadline = DateTime(year, month, day, 23, 59, 59);
      }
    } catch (e) {
      deadline = DateTime.now().add(const Duration(days: 7));
    }

    final assignTaskModel = AssignTaskToMemberModel(
      title: taskTitleController.text,
      description: taskDesController.text,
      assignedTo: selectedMember!.user!.id!,
      deadline: deadline,
    );

    context.read<TeamTaskManagementCubit>().assignTaskToMember(
          assignTaskModel: assignTaskModel,
          taskId: widget.taskId,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TeamTaskManagementCubit, TeamTaskManagementState>(
      listener: (context, state) {
        if (state is GetTeamMembersSuccess) {
          setState(() {
            teamMembers = state.teamMembers;
          });
        } else if (state is GetTeamMembersError) {
          CustomSnackbar.showError(
            title: 'assign_task.error'.tr(),
            message: state.errorMessage,
          );
        } else if (state is AssignTaskToMemberSuccess) {
          // Only close dialog, let parent screen handle success message and refresh
          Navigator.of(context).pop();
        } else if (state is AssignTaskToMemberError) {
          CustomSnackbar.showError(
            title: 'assign_task.error'.tr(),
            message: state.errorMessage,
          );
        }
      },
      child: Dialog(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _label("Task Title"),
                _inputField("The title of job ...",
                    controller: taskTitleController),
                const SizedBox(height: 16),
                _label("Task Description"),
                _inputField(
                  "Write the description of the job ...",
                  controller: taskDesController,
                  maxLines: 5,
                  maxLength: 500,
                ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: CustomContainerText(
                      text: "$descLength / 500",
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _label("Assign To"),
                BlocBuilder<TeamTaskManagementCubit, TeamTaskManagementState>(
                  builder: (context, state) {
                    if (state is GetTeamMembersLoading) {
                      return Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    return DropdownButtonFormField<TeamMemberModel>(
                      value: selectedMember,
                      items: teamMembers
                          .map((member) => DropdownMenuItem(
                                value: member,
                                child: Text(
                                  member.user?.name ?? 'Unknown',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface),
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedMember = value;
                        });
                      },
                      dropdownColor: Theme.of(context).colorScheme.surface,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        hintText: "Select team member",
                        hintStyle: const TextStyle(color: Colors.white54),
                      ),
                      style: const TextStyle(color: Colors.white),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _label("Deadline"),
                DateInputTextField(
                  controller: taskDeadLineController,
                  hintText: "YYYY/MM/DD",
                ),
                const SizedBox(height: 24),
                BlocBuilder<TeamTaskManagementCubit, TeamTaskManagementState>(
                  builder: (context, state) {
                    final isLoading = state is AssignTaskToMemberLoading;

                    return InkWell(
                      onTap: isLoading ? null : _handleAssignTask,
                      child: Container(
                        width: double.infinity,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isLoading
                              ? Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withValues(alpha: 0.6)
                              : Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : const CustomContainerText(
                                  text: "Create Task",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6.0),
        child: CustomContainerText(
          text: text,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      );

  Widget _inputField(String hint,
          {int maxLines = 1,
          int? maxLength,
          required TextEditingController controller}) =>
      TextField(
        controller: controller,
        maxLines: maxLines,
        maxLength: maxLength,
        style: const TextStyle(color: Colors.grey),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          counterText: "",
        ),
      );
}
