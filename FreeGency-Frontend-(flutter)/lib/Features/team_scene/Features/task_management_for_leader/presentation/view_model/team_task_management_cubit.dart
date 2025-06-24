import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/data/model/assign_task_to_member_model.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/data/model/sub_task_model.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/data/repository/implemented_team_task_management_repo.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/data/repository/task_management_for_team_repository.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/presentation/view_model/team_task_management_states.dart';
import 'package:freegency_gp/core/utils/local_storage/local_storage.dart';

class TeamTaskManagementCubit extends Cubit<TeamTaskManagementState> {
  TeamTaskManagementCubit() : super(TeamTaskManagementInitial());

  final TaskManagementForTeamRepository repository =
      ImplementedTeamTaskManagementRepo();

  bool isLoading = false;
  List<SubTaskModel> _currentSubTasks = []; // Local state for sub tasks

  /// Get all tasks assigned to the team
  Future<void> getTeamTasks() async {
    if (isLoading) return; // Prevent multiple simultaneous calls

    isLoading = true;
    emit(TeamTaskManagementLoading());

    // Check user role to determine which endpoint to call
    final isLeader = await LocalStorage.isTeamLeader();

    final result = isLeader
        ? await repository.getTasksForTeam() // Endpoint for leader
        : await repository.getAssignedTasksForMember(); // Endpoint for member

    result.fold(
      (error) {
        emit(TeamTaskManagementError(errorMessage: error));
      },
      (tasks) {
        emit(TeamTaskManagementSuccess(tasks: tasks));
      },
    );

    isLoading = false;
  }

  /// Checks if the current user is a team leader.
  Future<bool> isCurrentUserTeamLeader() async {
    return await LocalStorage.isTeamLeader();
  }

  /// Get team members for task assignment
  Future<void> getTeamMembers() async {
    emit(GetTeamMembersLoading());

    final result = await repository.getTeamMembers();
    result.fold(
      (failure) {
        emit(GetTeamMembersError(errorMessage: failure.errorMessage));
      },
      (teamMembers) {
        emit(GetTeamMembersSuccess(teamMembers: teamMembers));
      },
    );
  }

  /// Assign task to a team member
  Future<void> assignTaskToMember({
    required AssignTaskToMemberModel assignTaskModel,
    required String taskId,
  }) async {
    emit(AssignTaskToMemberLoading());

    final result = await repository.assignTaskToMember(assignTaskModel, taskId);
    result.fold(
      (failure) {
        emit(AssignTaskToMemberError(errorMessage: failure.errorMessage));
      },
      (message) {
        emit(AssignTaskToMemberSuccess(message: message));
      },
    );
  }

  /// Get sub tasks for a specific task
  Future<void> getSubTasks(String taskId) async {
    emit(GetSubTasksLoading());

    final result = await repository.getSubTasks(taskId);
    result.fold(
      (failure) {
        emit(GetSubTasksError(errorMessage: failure.errorMessage));
      },
      (subTasks) {
        _currentSubTasks = subTasks; // Store in local state
        emit(GetSubTasksSuccess(subTasks: subTasks));
      },
    );
  }

  /// Add comment to a sub task with optimistic updates
  Future<void> addCommentToSubTask({
    required String subTaskId,
    required String comment,
  }) async {
    // Enhanced validation
    if (subTaskId.isEmpty) {
      emit(AddCommentToSubTaskError(
        errorMessage: 'Sub task ID is required',
        revertedSubTasks: _currentSubTasks,
      ));
      return;
    }

    if (comment.trim().isEmpty) {
      emit(AddCommentToSubTaskError(
        errorMessage: 'Comment text is required',
        revertedSubTasks: _currentSubTasks,
      ));
      return;
    }

    log('🔄 TeamTaskManagementCubit: Starting optimistic comment update');
    log('   🔑 SubTaskId: $subTaskId');
    log('   💬 Comment: "${comment.trim()}"');

    // Step 1: Show loading state for this specific sub task
    emit(AddCommentToSubTaskLoading(subTaskId: subTaskId));

    // Step 2: Get current user data from local storage
    final currentUser = await LocalStorage.getUserData();
    String currentUserId = 'current_user';
    String currentUserName = 'You';
    String currentUserImage = '';

    if (currentUser != null) {
      currentUserId = currentUser.id ?? 'current_user';
      currentUserName = currentUser.name ?? 'You';
      currentUserImage = currentUser.image ?? '';
      log('👤 Current user: $currentUserName (ID: $currentUserId)');
    } else {
      log('⚠️ No current user data found, using default values');
    }

    // Step 3: Create optimistic comment
    final optimisticCommentId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
    final optimisticComment = Comment(
      id: optimisticCommentId,
      text: comment.trim(),
      user: AssignedTo(
        id: currentUserId,
        name: currentUserName,
        profileImage: currentUserImage,
      ),
    );

    // Step 4: Add optimistic comment to local state
    final updatedSubTasks = _currentSubTasks.map((subTask) {
      if (subTask.subtaskDetails.id == subTaskId) {
        final updatedComments = [...subTask.comments, optimisticComment];
        return SubTaskModel(
          subtaskDetails: subTask.subtaskDetails,
          assignedTo: subTask.assignedTo,
          comments: updatedComments,
        );
      }
      return subTask;
    }).toList();

    // Step 5: Update local state and UI
    _currentSubTasks = updatedSubTasks;
    emit(SubTasksUpdatedWithComment(
      subTasks: updatedSubTasks,
      pendingCommentId: optimisticCommentId,
    ));

    // Step 6: Send to server
    final result =
        await repository.addCommentToSubTask(subTaskId, comment.trim());

    result.fold(
      (failure) {
        log('❌ TeamTaskManagementCubit: addCommentToSubTask failed - ${failure.errorMessage}');

        // Step 7a: Revert optimistic update on failure
        final revertedSubTasks = _currentSubTasks.map((subTask) {
          if (subTask.subtaskDetails.id == subTaskId) {
            final revertedComments = subTask.comments
                .where((comment) => comment.id != optimisticCommentId)
                .toList();
            return SubTaskModel(
              subtaskDetails: subTask.subtaskDetails,
              assignedTo: subTask.assignedTo,
              comments: revertedComments,
            );
          }
          return subTask;
        }).toList();

        _currentSubTasks = revertedSubTasks;
        emit(AddCommentToSubTaskError(
          errorMessage: failure.errorMessage,
          revertedSubTasks: revertedSubTasks,
        ));
      },
      (message) {
        log('✅ TeamTaskManagementCubit: addCommentToSubTask success - $message');

        // Step 7b: Replace optimistic comment with real one from server
        // For now, we keep the optimistic comment since we don't get the real comment back
        // In a real implementation, you'd replace it with the server response

        emit(AddCommentToSubTaskSuccess(
          message: message,
          updatedSubTasks: _currentSubTasks,
        ));
      },
    );
  }

  /// Get current sub tasks (useful for widgets)
  List<SubTaskModel> get currentSubTasks => _currentSubTasks;
}
