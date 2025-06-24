import 'package:dartz/dartz.dart';
import 'package:freegency_gp/Features/team_scene/Features/my_jobs/data/models/job_model.dart';
import 'package:freegency_gp/core/errors/failures.dart';

abstract class AvailableJobsRepository {
  Future<Either<Failure, List<JobModel>>> getAvailableJobs(String? categoryId);
}

