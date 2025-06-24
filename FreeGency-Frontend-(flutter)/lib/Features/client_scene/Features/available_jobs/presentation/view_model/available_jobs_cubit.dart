import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/client_scene/Features/available_jobs/data/available_jobs_repository/available_jobs_repo.dart';
import 'package:freegency_gp/Features/client_scene/Features/available_jobs/data/available_jobs_repository/implemented_available_jobs_repo.dart';
import 'package:freegency_gp/Features/team_scene/Features/my_jobs/data/models/job_model.dart';

part 'available_jobs_states.dart';

class AvailableJobsCubit extends Cubit<AvailableJobsState> {
  AvailableJobsCubit() : super(AvailableJobsInitial());

  final AvailableJobsRepository availableJobsRepository =
      ImplementedAvailableJobsRepo(); // Initialize the repository

  bool _isClosed = false;

  @override
  Future<void> close() {
    _isClosed = true;
    return super.close();
  }

  Future<void> getAvailableJobs({String? categoryId}) async {
    if (_isClosed) return;

    log('🔄 Fetching jobs for categoryId: $categoryId');

    emit(AvailableJobsLoading());

    try {
      final result = await availableJobsRepository.getAvailableJobs(categoryId);

      if (_isClosed) return;

      result.fold(
        (failure) {
          log('❌ Error getting available jobs for categoryId $categoryId: ${failure.errorMessage}');
          emit(AvailableJobsError(errorMessage: failure.errorMessage));
        },
        (jobs) {
          log('✅ Successfully loaded ${jobs.length} available jobs for categoryId: $categoryId');
          emit(AvailableJobsSuccess(jobs: jobs));
        },
      );
    } catch (e) {
      if (!_isClosed) {
        log('💥 Unexpected error getting available jobs for categoryId $categoryId: $e');
        emit(AvailableJobsError(
            errorMessage: 'An unexpected error occurred: ${e.toString()}'));
      }
    }
  }

  void resetState() {
    if (!_isClosed) {
      emit(AvailableJobsInitial());
    }
  }

  void refreshJobs({String? categoryId}) {
    getAvailableJobs(categoryId: categoryId);
  }
}
