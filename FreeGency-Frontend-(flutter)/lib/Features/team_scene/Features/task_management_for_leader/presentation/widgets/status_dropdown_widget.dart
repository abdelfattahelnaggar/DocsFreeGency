import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/data/models/task_model.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/data/repository/implemented_team_task_management_repo.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/presentation/view_model/team_task_management_cubit.dart';
import 'package:freegency_gp/core/utils/helpers/custom_snackbar.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';
import 'package:iconsax/iconsax.dart';

class StatusDropdownWidget extends StatefulWidget {
  final TaskModel task;

  const StatusDropdownWidget({super.key, required this.task});

  @override
  State<StatusDropdownWidget> createState() => _StatusDropdownWidgetState();
}

class _StatusDropdownWidgetState extends State<StatusDropdownWidget> {
  late String selectedStatus;
  final List<String> statusOptions = [
    'In progress',
    'Completed',
  ];

  bool isUpdating = false;
  final _repository = ImplementedTeamTaskManagementRepo();

  @override
  void initState() {
    super.initState();
    // Initialize with task's current status, normalized to match dropdown options
    selectedStatus = _normalizeStatus(widget.task.status);
  }

  /// Normalize the status value to match dropdown options
  String _normalizeStatus(String? status) {
    if (status == null) return 'In progress';

    final normalizedStatus = status.toLowerCase().trim();

    switch (normalizedStatus) {
      case 'in-progress':
      case 'inprogress':
      case 'in progress':
        return 'In progress';
      case 'completed':
      case 'complete':
      case 'done':
        return 'Completed';
      case 'on hold':
      case 'onhold':
      case 'hold':
      case 'paused':
        return 'On hold';
      case 'cancelled':
      case 'canceled':
      case 'cancel':
        return 'Cancelled';
      default:
        return 'In progress'; // Default fallback
    }
  }

  /// Update task status in backend
  Future<void> _updateTaskStatus(String newStatus) async {
    if (isUpdating) return;

    setState(() {
      isUpdating = true;
    });

    try {
      // Only allow marking tasks as completed for now
      if (newStatus == 'Completed' && widget.task.id != null) {
        final result = await _repository.updateTaskStatus(widget.task.id!);

        result.fold(
          (failure) {
            // Revert status change on error
            setState(() {
              selectedStatus = _normalizeStatus(widget.task.status);
              isUpdating = false;
            });

            // Show error snackbar
            CustomSnackbar.showError(
              title: 'Update Failed',
              message: failure.errorMessage,
            );
          },
          (successMessage) {
            // Update was successful
            setState(() {
              isUpdating = false;
            });

            // Show success snackbar
            CustomSnackbar.showSuccess(
              title: 'Task Updated',
              message: 'Task status updated successfully',
            );

            // Refetch data to update the UI
            context.read<TeamTaskManagementCubit>().getTeamTasks();
          },
        );
      }
    } catch (e) {
      // Revert status change on error
      setState(() {
        selectedStatus = _normalizeStatus(widget.task.status);
        isUpdating = false;
      });

      // Show error snackbar
      CustomSnackbar.showError(
        title: 'Update Failed',
        message: 'An unexpected error occurred',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.surface,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedStatus,
          icon: isUpdating
              ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          dropdownColor: Theme.of(context).colorScheme.surface,
          style: AppTextStyles.poppins14Regular(context)!.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
          borderRadius: BorderRadius.circular(12),
          selectedItemBuilder: (BuildContext context) {
            return statusOptions.map((String value) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    value,
                    style: AppTextStyles.poppins14Regular(context)!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (!isUpdating)
                    Icon(
                      Iconsax.arrow_down_1,
                      size: 18,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                ],
              );
            }).toList();
          },
          items: statusOptions.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (widget.task.status == 'in-progress' && !isUpdating)
              ? (String? newValue) {
                  if (newValue != null && newValue != selectedStatus) {
                    setState(() {
                      selectedStatus = newValue;
                    });

                    // Update task status in backend
                    _updateTaskStatus(newValue);
                  }
                }
              : null,
        ),
      ),
    );
  }
}
