part of 'tasks_functionality_cubit.dart';

@immutable
sealed class TasksFunctionalityState {}

final class TasksFunctionalityInitial extends TasksFunctionalityState {}

final class GetTaskByIdLoading extends TasksFunctionalityState {}

final class GetTaskByIdError extends TasksFunctionalityState {
  final String errorMessage;
  GetTaskByIdError(this.errorMessage);
}

final class GetTaskByIdSuccess extends TasksFunctionalityState {
  final TaskModel task;
  GetTaskByIdSuccess(this.task);
}

final class GetTaskRequestsLoading extends TasksFunctionalityState {}

final class GetTaskRequestsError extends TasksFunctionalityState {
  final String errorMessage;
  GetTaskRequestsError(this.errorMessage);
}

final class GetTaskRequestsSuccess extends TasksFunctionalityState {
  final TaskRequestsModel taskRequests;
  GetTaskRequestsSuccess(this.taskRequests);
}




