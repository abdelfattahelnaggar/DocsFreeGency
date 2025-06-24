part of 'available_jobs_cubit.dart';

abstract class AvailableJobsState {}

final class AvailableJobsInitial extends AvailableJobsState {}

final class AvailableJobsLoading extends AvailableJobsState {}

final class AvailableJobsSuccess extends AvailableJobsState {
  final List<JobModel> jobs;

  AvailableJobsSuccess({required this.jobs});
}

final class AvailableJobsError extends AvailableJobsState {
  final String errorMessage;

  AvailableJobsError({required this.errorMessage});
}
