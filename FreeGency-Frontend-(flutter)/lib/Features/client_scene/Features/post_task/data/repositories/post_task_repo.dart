import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:freegency_gp/Features/client_scene/Features/post_task/data/models/post_task_request_model.dart';
import 'package:freegency_gp/core/errors/failures.dart';

abstract class PostTaskRepo {
  Future<Either<Failure, File>> chooseFileFromDevice();
  Future<Either<Failure, dynamic>> postTask(
      PostTaskRequestModel postTaskRequestModel);
}
