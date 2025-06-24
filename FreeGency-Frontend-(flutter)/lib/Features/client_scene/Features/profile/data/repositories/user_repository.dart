import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/data/models/my_tasks_response_model.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/data/models/user_model.dart';
import 'package:freegency_gp/Features/settings/data/models/update_user_profile_request_model.dart';
import 'package:freegency_gp/core/errors/failures.dart';

abstract class UserRepository {
  Future<Either<Failure, UserModel>> getUser();
  Future<Either<Failure, UserModel>> updateUser(
      UpdateUserProfileRequestModel requestModel);
  Future<void> uploadImage(File image);
  Future<Either<Failure, MyTasksResponseModel>> getMyTasks();
}
