part of 'my_team_functionality_cubit_cubit.dart';

@immutable
sealed class MyTeamFunctionalityCubitState {}

final class MyTeamFunctionalityCubitInitial
    extends MyTeamFunctionalityCubitState {}

final class MyTeamFunctionalityCubitLoading
    extends MyTeamFunctionalityCubitState {}

final class MyTeamFunctionalityCubitSuccess
    extends MyTeamFunctionalityCubitState {
  final List<TaskModel> tasks;
  MyTeamFunctionalityCubitSuccess({required this.tasks});
}

final class MyTeamFunctionalityCubitError
    extends MyTeamFunctionalityCubitState {
  final String errorMessage;
  MyTeamFunctionalityCubitError({required this.errorMessage});
}

final class TaskSavingSuccess extends MyTeamFunctionalityCubitState {
  final String message;
  TaskSavingSuccess({required this.message});
}

final class TaskSavingError extends MyTeamFunctionalityCubitState {
  final String errorMessage;
  TaskSavingError({required this.errorMessage});
}

final class SavingTaskLoading extends MyTeamFunctionalityCubitState {}

final class SavingTaskError extends MyTeamFunctionalityCubitState {
  final String errorMessage;
  SavingTaskError(this.errorMessage);
}

final class SavingTaskSuccess extends MyTeamFunctionalityCubitState {
  final String message;
  SavingTaskSuccess(this.message);
}
