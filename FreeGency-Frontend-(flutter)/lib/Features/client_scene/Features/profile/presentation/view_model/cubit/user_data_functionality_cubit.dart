import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/data/models/my_tasks_response_model.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/data/models/user_model.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/data/repositories/user_repository.dart';
import 'package:freegency_gp/Features/settings/data/models/update_user_profile_request_model.dart';

part 'user_data_functionality_state.dart';

class UserDataFunctionalityCubit extends Cubit<UserDataFunctionalityState> {
  UserDataFunctionalityCubit(this.userRepo)
      : super(UserDataFunctionalityInitial());
  UserRepository userRepo;

  UserModel? _cachedUserData;
  MyTasksResponseModel? _cachedTasksData;
  bool _hasLoadedData = false;

  bool get hasData => _hasLoadedData && _cachedUserData != null;

  UserModel? get cachedUserData => _cachedUserData;

  MyTasksResponseModel? get cachedTasksData => _cachedTasksData;

  bool get hasTasksData => _cachedTasksData != null;

  Future<void> getUser({bool forceRefresh = false}) async {
    if (!forceRefresh && _cachedUserData != null) {
      emit(GetUserDataSuccess(_cachedUserData!));
      return;
    }

    emit(GetUserDataLoading());
    var result = await userRepo.getUser();

    result.fold((failure) {
      emit(GetUserDataError(failure.errorMessage));
    }, (userModel) {
      _cachedUserData = userModel;
      emit(GetUserDataSuccess(userModel));
    });
  }

  Future<void> updateUser(UpdateUserProfileRequestModel requestModel) async {
    emit(UpdateUserDataLoading());
    var result = await userRepo.updateUser(requestModel);

    result.fold((failure) {
      emit(UpdateUserDataError(failure.errorMessage));
    }, (userModel) {
      _cachedUserData = userModel;
      emit(UpdateUserDataSuccess(userModel));
    });
  }

  void addSkill(String skill) {
    if (_cachedUserData == null) return;
    final newSkills = List<String>.from(_cachedUserData!.skills)..add(skill);
    _cachedUserData = _cachedUserData!.copyWith(skills: newSkills);
    emit(GetUserDataSuccess(_cachedUserData!));
  }

  void removeSkill(String skill) {
    if (_cachedUserData == null) return;
    final newSkills = List<String>.from(_cachedUserData!.skills)..remove(skill);
    _cachedUserData = _cachedUserData!.copyWith(skills: newSkills);
    emit(GetUserDataSuccess(_cachedUserData!));
  }

  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    emit(PasswordChanging());
    // NOTE: API service does not have a change password method. This is a placeholder.
    // You should have a repository method that calls the change password API endpoint.
    await Future.delayed(const Duration(seconds: 1));
    // on success
    emit(PasswordChanged());
    // on error
    // emit(PasswordChangeError("Error message"));
  }

  Future<void> uploadImage(File image) async {
    final currentState = state;

    try {
      emit(UploadImageLoading());

      await userRepo.uploadImage(image);

      await _updateUserDataOnly();
    } catch (e) {
      emit(currentState);
      emit(UploadImageError(e.toString()));
    }
  }

  Future<void> _updateUserDataOnly() async {
    try {
      var result = await userRepo.getUser();

      result.fold((failure) {
        emit(UploadImageError(failure.errorMessage));
      }, (userModel) {
        _cachedUserData = userModel;

        if (_hasLoadedData && _cachedTasksData != null) {
          // إصدار نفس الحالة مع المهام الموجودة
          emit(GetAllUserDataSuccess(userModel, _cachedTasksData!));
        } else {
          // إذا لم تكن المهام متاحة، نصدر فقط حالة نجاح بيانات المستخدم
          emit(GetUserDataSuccess(userModel));
        }
      });
    } catch (e) {
      emit(UploadImageError(e.toString()));
    }
  }

  Future<void> getMyTasks({bool forceRefresh = false}) async {
    if (!forceRefresh && _cachedTasksData != null) {
      emit(GetMyTasksSuccess(_cachedTasksData!));
      return;
    }

    emit(GetMyTasksLoading());
    var result = await userRepo.getMyTasks();
    result.fold((failure) {
      emit(GetMyTasksError(failure.errorMessage));
    }, (myTasksModel) {
      _cachedTasksData = myTasksModel;
      emit(GetMyTasksSuccess(myTasksModel));
    });
  }

  Future<void> getUserWithTasks({bool forceRefresh = false}) async {
    if (!forceRefresh &&
        _hasLoadedData &&
        _cachedUserData != null &&
        _cachedTasksData != null) {
      emit(GetAllUserDataSuccess(_cachedUserData!, _cachedTasksData!));
      return;
    }

    emit(GetAllUserDataLoading());

    try {
      final userResult = await userRepo.getUser();

      final tasksResult = await userRepo.getMyTasks();

      userResult.fold((userFailure) {
        emit(GetAllUserDataError(userFailure.errorMessage));
      }, (userModel) {
        tasksResult.fold((tasksFailure) {
          emit(GetAllUserDataError(tasksFailure.errorMessage));
        }, (tasksModel) {
          _cachedUserData = userModel;
          _cachedTasksData = tasksModel;
          _hasLoadedData = true;

          emit(GetAllUserDataSuccess(userModel, tasksModel));
        });
      });
    } catch (e) {
      emit(GetAllUserDataError(e.toString()));
    }
  }

  Future<void> refreshAllData() async {
    emit(GetAllUserDataLoading());
    await getUserWithTasks(forceRefresh: true);
  }
}
