import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/data/models/project_model.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/presentation/widgets/leave_comment_section.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/presentation/widgets/user_comment_item.dart';
import 'package:freegency_gp/core/shared/data/repositories/reviews_repo/implemented_reviews_repo.dart';
import 'package:freegency_gp/core/shared/view_model/reviews_cubit/reviews_cubit.dart';
import 'package:freegency_gp/core/shared/view_model/reviews_cubit/rewies_states.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';
import 'package:get/get.dart';

class ProjectCommentsAndRateSection extends StatefulWidget {
  const ProjectCommentsAndRateSection({
    super.key,
  });

  @override
  State<ProjectCommentsAndRateSection> createState() =>
      _ProjectCommentsAndRateSectionState();
}

class _ProjectCommentsAndRateSectionState
    extends State<ProjectCommentsAndRateSection> {
  late ReviewsCubit _reviewsCubit;
  late String projectId;

  @override
  void initState() {
    super.initState();
    final projectModel = Get.arguments as ProjectModel;
    final String projectId = projectModel.id!;
    this.projectId = projectId;
    _reviewsCubit = ReviewsCubit(ImplementedReviewsRepo());
    _reviewsCubit.getReviews(projectId);
  }

  @override
  void dispose() {
    _reviewsCubit.close();
    super.dispose();
  }

  void _refreshReviews() {
    _reviewsCubit.getReviews(projectId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _reviewsCubit,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LeaveCommentSection(
              targetId: projectId,
              targetKey: 'ratedProject',
              onReviewSubmitted: _refreshReviews,
            ),
            ReusableTextStyleMethods.poppins16BoldMethod(
                context: context, text: 'Comments'),
            BlocBuilder<ReviewsCubit, ReviewsState>(
              builder: (context, state) {
                if (state is GetReviewsLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is GetReviewsError) {
                  return Center(
                    child: Text(
                      'Failed to load reviews: ${state.errorMessage}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  );
                } else if (state is GetReviewsSuccess) {
                  if (state.reviews.isEmpty) {
                    return const Center(
                      child: Text('No reviews yet'),
                    );
                  }
                  return Column(
                    children: state.reviews.map((review) {
                      final comment = {
                        'publisherImage': review.ratedBy.profileImage ?? '',
                        'clientName': review.ratedBy.name,
                        'postedAt': _formatDate(review.createdAt),
                        'comment': review.review,
                        'rating': review.rating,
                      };
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: UsersCommentsItem(comment: comment),
                      );
                    }).toList(),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            40.height,
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}
