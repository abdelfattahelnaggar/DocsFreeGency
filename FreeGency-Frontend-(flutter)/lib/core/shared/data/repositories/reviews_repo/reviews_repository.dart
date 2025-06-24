import 'package:dartz/dartz.dart';
import 'package:freegency_gp/core/errors/failures.dart';
import 'package:freegency_gp/core/shared/data/models/review_request_model.dart';

abstract class ReviewsRepository {
  Future<Either<Failure, String>> addReview(
      ReviewRequestModel reviewRequestModel);
  Future<Either<Failure, List<ReviewResponseModel>>> getReviews(
      String projectId);
}
