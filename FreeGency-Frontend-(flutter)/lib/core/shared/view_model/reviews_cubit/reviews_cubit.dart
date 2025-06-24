import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/core/shared/data/models/review_request_model.dart';
import 'package:freegency_gp/core/shared/data/repositories/reviews_repo/reviews_repository.dart';
import 'package:freegency_gp/core/shared/view_model/reviews_cubit/rewies_states.dart';

class ReviewsCubit extends Cubit<ReviewsState> {
  final ReviewsRepository reviewsRepository;

  ReviewsCubit(this.reviewsRepository) : super(ReviewsInitial());

  Future<void> addReview(ReviewRequestModel reviewRequestModel) async {
    emit(AddReviewLoading());

    try {
      final result = await reviewsRepository.addReview(reviewRequestModel);

      result.fold(
        (failure) {
          emit(AddReviewError(failure.errorMessage));
        },
        (successMessage) {
          emit(AddReviewSuccess(successMessage));
        },
      );
    } catch (e) {
      emit(AddReviewError('An unexpected error occurred: ${e.toString()}'));
    }
  }

  Future<void> getReviews(String projectId) async {
    emit(GetReviewsLoading());

    try {
      final result = await reviewsRepository.getReviews(projectId);

      result.fold(
        (failure) {
          emit(GetReviewsError(failure.errorMessage));
        },
        (reviews) {
          emit(GetReviewsSuccess(reviews));
        },
      );
    } catch (e) {
      emit(GetReviewsError('An unexpected error occurred: ${e.toString()}'));
    }
  }

  void resetState() {
    emit(ReviewsInitial());
  }
}
