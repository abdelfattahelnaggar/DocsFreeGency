
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/data/models/teams_model.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';

class RatingSection extends StatelessWidget {
  const RatingSection({
    super.key,
    required this.team,
  });

  final TeamsModel team;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.star,
          color: Colors.amber,
          size: 16.sp,
        ),
        SizedBox(width: 4.w),
        Text(
          '${team.averageRating ?? 0}',
          style: AppTextStyles.poppins12Regular(context)!
              .copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          '(${team.ratingCount} ${context.tr('reviews')})',
          style: AppTextStyles.poppins12Regular(context)!
              .copyWith(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 10.sp,
          ),
        ),
      ],
    );
  }
}