import 'package:freegency_gp/Features/team_scene/Features/my_jobs/data/models/job_model.dart';

abstract class MyJobsState {}

class MyJobsInitial extends MyJobsState {}

class MyJobsLoading extends MyJobsState {}

class MyJobsSuccess extends MyJobsState {
  final List<JobModel> jobs;
  MyJobsSuccess(this.jobs);
}

class MyJobsError extends MyJobsState {
  final String errorMessage;
  MyJobsError(this.errorMessage);
}

class JobDetailsLoading extends MyJobsState {}

class JobDetailsSuccess extends MyJobsState {
  final JobModel job;
  JobDetailsSuccess(this.job);
}

class JobDetailsError extends MyJobsState {
  final String errorMessage;
  JobDetailsError(this.errorMessage);
}

class DeleteJobLoading extends MyJobsState {}

class DeleteJobSuccess extends MyJobsState {}

class DeleteJobError extends MyJobsState {
  final String errorMessage;
  DeleteJobError(this.errorMessage);
}



