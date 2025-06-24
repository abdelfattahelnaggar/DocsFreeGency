import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/team_scene/Features/my_jobs/data/repositories/implemented_my_jobs_repository.dart';
import 'package:freegency_gp/Features/team_scene/Features/my_jobs/data/repositories/my_jobs_repository.dart';
import 'package:freegency_gp/Features/team_scene/Features/my_jobs/presentation/view_model/cubits/my_jobs_cubit/my_jobs_state.dart';

class MyJobsCubit extends Cubit<MyJobsState> {
  final MyJobsRepository _repository;

  MyJobsCubit({MyJobsRepository? repository})
      : _repository = repository ?? ImplementedMyJobsRepository(),
        super(MyJobsInitial());

  Future<void> getMyJobs() async {
    emit(MyJobsLoading());

    try {
      final result = await _repository.getMyJobs();
      result.fold(
        (failure) {
          log('Error getting jobs: ${failure.errorMessage}');
          emit(MyJobsError(failure.errorMessage));
        },
        (jobs) {
          emit(MyJobsSuccess(jobs));
        },
      );
    } catch (error) {
      log('Unexpected error getting jobs: $error');
      emit(MyJobsError('An unexpected error occurred'));
    }
  }

  // Get job details by ID
  Future<void> getJobById(String jobId) async {
    emit(JobDetailsLoading());

    try {
      final result = await _repository.getJobById(jobId);
      result.fold(
        (failure) {
          log('Error getting job details: ${failure.errorMessage}');
          emit(JobDetailsError(failure.errorMessage));
        },
        (job) {
          emit(JobDetailsSuccess(job));
        },
      );
    } catch (error) {
      log('Unexpected error getting job details: $error');
      emit(JobDetailsError('An unexpected error occurred'));
    }
  }

  // Delete a job
  Future<void> deleteJob(String jobId) async {
    emit(DeleteJobLoading());

    try {
      final result = await _repository.deleteJob(jobId);
      result.fold(
        (failure) {
          log('Error deleting job: ${failure.errorMessage}');
          emit(DeleteJobError(failure.errorMessage));
        },
        (success) {
          emit(DeleteJobSuccess());
          // Refresh the jobs list after successful deletion
          refreshJobs();
        },
      );
    } catch (error) {
      log('Unexpected error deleting job: $error');
      emit(DeleteJobError('An unexpected error occurred'));
    }
  }

  Future<void> refreshJobs() async {
    await getMyJobs();
  }
}
