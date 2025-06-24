part of 'post_job_cubit.dart';

abstract class PostJobState {}

class PostJobInitial extends PostJobState {}

class PostJobLoading extends PostJobState {}

class PostJobSuccess extends PostJobState {
  final PostJobResponseModel postJobResponse;

  PostJobSuccess(this.postJobResponse);
}

class PostJobError extends PostJobState {
  final String errorMessage;

  PostJobError({required this.errorMessage});
}
