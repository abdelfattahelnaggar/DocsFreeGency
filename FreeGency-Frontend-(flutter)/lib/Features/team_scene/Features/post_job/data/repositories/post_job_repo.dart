import 'package:dartz/dartz.dart';
import 'package:freegency_gp/Features/team_scene/Features/post_job/data/models/post_job_request_model.dart';
import 'package:freegency_gp/Features/team_scene/Features/post_job/data/models/post_job_response_model.dart';
import 'package:freegency_gp/core/errors/failures.dart';

abstract class PostJobRepo {
  Future<Either<Failure, PostJobResponseModel?>> postJob(
    PostJobRequestModel postJobRequestModel,
  );
}
