import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/team_scene/Features/post_job/data/models/post_job_request_model.dart';
import 'package:freegency_gp/Features/team_scene/Features/post_job/data/models/post_job_response_model.dart';
import 'package:freegency_gp/Features/team_scene/Features/post_job/data/repositories/post_job_repo.dart';

part 'post_job_state.dart';

class PostJobCubit extends Cubit<PostJobState> {
  PostJobCubit(this.postJobRepo) : super(PostJobInitial());

  final PostJobRepo postJobRepo;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final List<String> requiredSelectedSkills = [];

  Future<void> postJob(PostJobRequestModel postJobRequestModel) async {
    emit(PostJobLoading());
    final response = await postJobRepo.postJob(postJobRequestModel);
    response.fold(
      (failure) {
        log('❌ Post Job Error: ${failure.errorMessage}');
        emit(PostJobError(errorMessage: failure.errorMessage));
      },
      (data) {
        if (data?.status == 'success' && data?.data != null) {
          emit(PostJobSuccess(data!));
        } else {
          final errorMessage =
              data?.message ?? 'Something went wrong. Please try again.';
          log('❌ Post Job Error: $errorMessage');
          emit(PostJobError(errorMessage: errorMessage));
        }
      },
    );
  }

  void clearAllFields() {
    titleController.clear();
    descriptionController.clear();
    requiredSelectedSkills.clear();
    emit(PostJobInitial());
  }

  @override
  Future<void> close() {
    titleController.dispose();
    descriptionController.dispose();
    return super.close();
  }
}
