import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/core/shared/data/models/review_request_model.dart';
import 'package:freegency_gp/core/shared/view_model/reviews_cubit/reviews_cubit.dart';
import 'package:freegency_gp/core/shared/view_model/reviews_cubit/rewies_states.dart';
import 'package:freegency_gp/core/shared/widgets/call_to_action_button.dart';
import 'package:freegency_gp/core/shared/widgets/custom_snackbar.dart';
import 'package:freegency_gp/core/shared/widgets/star_rating_widget.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';
import 'package:iconsax/iconsax.dart';

class LeaveCommentSection extends StatefulWidget {
  final String targetId;
  final String targetKey; // 'ratedProject' or 'ratedTeam'
  final VoidCallback? onReviewSubmitted;
  
  const LeaveCommentSection({
    super.key,
    required this.targetId,
    required this.targetKey,
    this.onReviewSubmitted,
  });

  @override
  State<LeaveCommentSection> createState() => _LeaveCommentSectionState();
}

class _LeaveCommentSectionState extends State<LeaveCommentSection> {
  final TextEditingController _commentController = TextEditingController();
  int _selectedRating = 0;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitReview(BuildContext context) {
    if (_selectedRating == 0) {
      showAppSnackBar(
        context,
        message: 'Please select a rating before submitting',
        type: SnackBarType.error,
      );
      return;
    }

    if (_commentController.text.trim().isEmpty) {
      showAppSnackBar(
        context,
        message: 'Please write a review before submitting',
        type: SnackBarType.error,
      );
      return;
    }

    final reviewRequest = ReviewRequestModel(
      targetId: widget.targetId,
      review: _commentController.text.trim(),
      rating: _selectedRating,
      targetKey: widget.targetKey,
    );

    context.read<ReviewsCubit>().addReview(reviewRequest);
  }

  void _clearForm() {
    setState(() {
      _selectedRating = 0;
      _commentController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReviewsCubit, ReviewsState>(
      listener: (context, state) {
        if (state is AddReviewSuccess) {
          showAppSnackBar(
            context,
            message: state.message,
            type: SnackBarType.success,
          );
          _clearForm();
          // Trigger refresh of reviews in parent widget
          widget.onReviewSubmitted?.call();
        } else if (state is AddReviewError) {
          showAppSnackBar(
            context,
            message: state.errorMessage,
            type: SnackBarType.error,
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AddReviewLoading;
        
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 24),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Star Rating
              Center(
                child: StarRating(
                  starCount: 5,
                  size: 32.0,
                  spacing: 4.0,
                  initialRating: _selectedRating.toDouble(),
                  fillColor: const Color(0xFFFFC73A),
                  strokeColor: const Color(0xFF666666),
                  isEnabled: !isLoading,
                  onRatingChanged: (rating) {
                    setState(() {
                      _selectedRating = rating;
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),
              
              // Comment TextField
              TextField(
                controller: _commentController,
                enabled: !isLoading,
                decoration: InputDecoration(
                  hintText: 'Leave a comment...',
                  hintStyle: AppTextStyles.poppins14Regular(context),
                  border: InputBorder.none,
                ),
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 16),
              
              // Submit Button
              PrimaryCTAButton(
                label: isLoading ? 'Submitting...' : 'Post',
                onTap: isLoading ? null : () => _submitReview(context),
                child: isLoading 
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    )
                  : const Icon(Iconsax.send_2, color: Colors.white),
              ),
            ],
          ),
        );
      },
    );
  }
}
