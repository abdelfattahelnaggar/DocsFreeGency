import 'package:freegency_gp/core/shared/data/models/review_request_model.dart';

abstract class ReviewsState {}

class ReviewsInitial extends ReviewsState {}

// Add Review States
class AddReviewLoading extends ReviewsState {}

class AddReviewSuccess extends ReviewsState {
  final String message;
  AddReviewSuccess(this.message);
}

class AddReviewError extends ReviewsState {
  final String errorMessage;
  AddReviewError(this.errorMessage);
}

// Get Reviews States
class GetReviewsLoading extends ReviewsState {}

class GetReviewsSuccess extends ReviewsState {
  final List<ReviewResponseModel> reviews;
  GetReviewsSuccess(this.reviews);
}

class GetReviewsError extends ReviewsState {
  final String errorMessage;
  GetReviewsError(this.errorMessage);
}
