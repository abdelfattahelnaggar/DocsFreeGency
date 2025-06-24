import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/client_scene/Features/post_task/data/models/post_task_request_model.dart';
import 'package:freegency_gp/Features/client_scene/Features/post_task/data/models/post_task_response_model.dart';
import 'package:freegency_gp/Features/client_scene/Features/post_task/data/repositories/post_task_repo.dart';

part 'post_task_from_client_state.dart';

class PostTaskFromClientCubit extends Cubit<PostTaskFromClientState> {
  PostTaskFromClientCubit(this.postTaskRepo)
      : super(PostTaskFromClientInitial());

  final PostTaskRepo postTaskRepo;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController budgetController = TextEditingController();
  final TextEditingController deadlineController = TextEditingController();
  File? pickedFile;
  final List<String> requiredSelectedSkills = [];

  Future<File?> chooseFileFromDevice() async {
    final response = await postTaskRepo.chooseFileFromDevice();
    return response.fold(
      (failure) {
        emit(PostTaskFromClientError(errorMessage: failure.errorMessage));
        return null;
      },
      (file) {
        emit(FilePickedSuccessfully(file));
        pickedFile = file;
        return file;
      },
    );
  }

  Future<void> postTask(PostTaskRequestModel postTaskRequestModel) async {
    emit(PostTaskFromClientLoading());
    final response = await postTaskRepo.postTask(postTaskRequestModel);
    response.fold(
      (failure) {
        log('❌ Post Task Error: ${failure.errorMessage}');
        emit(PostTaskFromClientError(errorMessage: failure.errorMessage));
      },
      (data) {
        if (data?.status == 'success' && data?.data != null) {
          emit(PostTaskFromClientSuccess(data!));
        } else {
          final errorMessage =
              data?.message ?? 'Something went wrong. Please try again.';
          log('❌ Post Task Error: $errorMessage');
          emit(PostTaskFromClientError(errorMessage: errorMessage));
        }
      },
    );
  }

  void clearFile() {
    pickedFile = null;
    emit(PostTaskFromClientInitial());
  }

  void clearAllFields() {
    titleController.clear();
    descriptionController.clear();
    budgetController.clear();
    deadlineController.clear();
    pickedFile = null;
    emit(PostTaskFromClientInitial());
  }
}
