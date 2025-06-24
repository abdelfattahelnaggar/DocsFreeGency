import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:freegency_gp/Features/team_scene/Features/team_profile/data/data/post_project_request_model.dart';
import 'package:freegency_gp/Features/team_scene/Features/team_profile/data/data/post_project_response_model.dart';
import 'package:freegency_gp/core/errors/failures.dart';

abstract class PostProjectRepo {
  Future<Either<Failure, List<File>>> chooseImagesFromDevice();
  Future<Either<Failure, PostProjectResponseModel>> postProject(
      PostProjectRequestModel postProjectRequestModel);
}
