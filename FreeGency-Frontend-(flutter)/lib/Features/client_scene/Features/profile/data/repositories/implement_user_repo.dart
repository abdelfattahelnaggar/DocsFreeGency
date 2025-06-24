import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/data/models/my_tasks_response_model.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/data/models/user_model.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/data/repositories/user_repository.dart';
import 'package:freegency_gp/Features/settings/data/models/update_user_profile_request_model.dart';
import 'package:freegency_gp/core/errors/failures.dart';
import 'package:freegency_gp/core/utils/constants/apis.dart';
import 'package:freegency_gp/core/utils/local_storage/local_storage.dart';
import 'package:freegency_gp/core/utils/services/api_service.dart';

class ImplementUserRepo implements UserRepository {
  @override
  Future<Either<Failure, UserModel>> getUser() async {
    try {
      final token = await LocalStorage.getToken();
      final response = await ApiService.instance.getData(
        path: ApiConstants.userProfileEndPoint,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final userModel = UserModel.fromJson(response['user']);
      await LocalStorage.setUserData(userModel);
      return right(userModel);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else if (e is Failure) {
        return left(e);
      } else {
        return left(ServerFailure(errorMessage: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, UserModel>> updateUser(
      UpdateUserProfileRequestModel requestModel) async {
    try {
      final token = await LocalStorage.getToken();
      final response = await ApiService.instance.patchData(
        path: ApiConstants.userProfileEndPoint,
        body: requestModel.toJson(),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final userModel = UserModel.fromJson(response['user']);
      await LocalStorage.setUserData(userModel);
      return right(userModel);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else if (e is Failure) {
        return left(e);
      } else {
        return left(ServerFailure(errorMessage: e.toString()));
      }
    }
  }

  @override
  Future<void> uploadImage(File image) async {
    try {
      final dio = Dio();

      final token = await LocalStorage.getToken();
      FormData formData = FormData.fromMap({
        'profileImage': await MultipartFile.fromFile(image.path),
      });

      final response = await dio.patch(
          'https://free-gency-backend-003bbc67b812.herokuapp.com/api/v1/users/my-image',
          data: formData,
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ));
      log('Upload Image Response Success');
    } catch (e) {
      if (e is DioException) {
        throw ServerFailure.fromDioError(e);
      } else if (e is Failure) {
        throw ServerFailure(errorMessage: e.errorMessage);
      } else {
        throw ServerFailure(errorMessage: e.toString());
      }
    }
  }

  @override
  Future<Either<Failure, MyTasksResponseModel>> getMyTasks() async {
    try {
      final token = await LocalStorage.getToken();
      final response = await ApiService.instance.getData(
        path: ApiConstants.myTasksEndPoint,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final myTasksModel = MyTasksResponseModel.fromJson(response);
      return right(myTasksModel);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else if (e is Failure) {
        return left(e);
      } else {
        return left(ServerFailure(errorMessage: e.toString()));
      }
    }
  }
}
