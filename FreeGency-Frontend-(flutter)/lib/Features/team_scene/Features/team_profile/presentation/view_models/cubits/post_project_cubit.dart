import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/team_scene/Features/team_profile/data/data/post_project_request_model.dart';
import 'package:freegency_gp/Features/team_scene/Features/team_profile/data/data/post_project_response_model.dart';
import 'package:freegency_gp/Features/team_scene/Features/team_profile/data/repositories/post_project_repo.dart';

part 'post_project_state.dart';

class PostProjectCubit extends Cubit<PostProjectState> {
  PostProjectCubit(this.postProjectRepo) : super(PostProjectInitial());

  final PostProjectRepo postProjectRepo;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController budgetController = TextEditingController();
  final TextEditingController projectUrlController = TextEditingController();
  final TextEditingController completionDateController =
      TextEditingController();
  List<File>? pickedImages;
  final List<String> selectedTechnologies = [];

  Future<List<File>?> chooseImagesFromDevice() async {
    final response = await postProjectRepo.chooseImagesFromDevice();
    return response.fold(
      (failure) {
        emit(PostProjectError(errorMessage: failure.errorMessage));
        return null;
      },
      (newImages) {
        // إضافة الصور الجديدة للموجودة بدلاً من استبدالها
        if (pickedImages == null) {
          pickedImages = List.from(newImages);
        } else {
          pickedImages!.addAll(newImages);
        }
        emit(ImagesPickedSuccessfully(pickedImages!));
        return pickedImages;
      },
    );
  }

  Future<void> postProject(
      PostProjectRequestModel postProjectRequestModel) async {
    emit(PostProjectLoading());
    final response = await postProjectRepo.postProject(postProjectRequestModel);
    response.fold(
      (failure) {
        log('❌ Post Project Error: ${failure.errorMessage}');
        emit(PostProjectError(errorMessage: failure.errorMessage));
      },
      (data) {
        if (data.isSuccess && data.data?.project != null) {
          emit(PostProjectSuccess(data));
        } else {
          final errorMessage = data.hasErrors
              ? data.errorMessage
              : 'Something went wrong. Please try again.';
          log('❌ Post Project Error: $errorMessage');
          emit(PostProjectError(errorMessage: errorMessage));
        }
      },
    );
  }

  void clearImages() {
    pickedImages = null;
    emit(PostProjectInitial());
  }

  void removeImage(int index) {
    if (pickedImages != null && index < pickedImages!.length) {
      pickedImages!.removeAt(index);
      if (pickedImages!.isEmpty) {
        pickedImages = null;
        emit(PostProjectInitial());
      } else {
        emit(ImagesPickedSuccessfully(pickedImages!));
      }
    }
  }

  void addTechnology(String technology) {
    if (!selectedTechnologies.contains(technology)) {
      selectedTechnologies.add(technology);
      emit(TechnologiesUpdated(List.from(selectedTechnologies)));
    }
  }

  void removeTechnology(String technology) {
    selectedTechnologies.remove(technology);
    emit(TechnologiesUpdated(List.from(selectedTechnologies)));
  }

  void clearAllFields() {
    titleController.clear();
    descriptionController.clear();
    budgetController.clear();
    projectUrlController.clear();
    completionDateController.clear();
    pickedImages = null;
    selectedTechnologies.clear();
    emit(PostProjectInitial());
  }

  @override
  Future<void> close() {
    titleController.dispose();
    descriptionController.dispose();
    budgetController.dispose();
    projectUrlController.dispose();
    completionDateController.dispose();
    return super.close();
  }
}
