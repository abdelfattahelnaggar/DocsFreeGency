import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/data/models/teams_model.dart';
import 'package:freegency_gp/core/utils/constants/routes.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class TopTeamsSection extends StatelessWidget {
  const TopTeamsSection({
    super.key,
    required this.team,
  });

  final TeamsModel team;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.specificTeamProfile, arguments: team);
      },
      child: Container(
        margin: EdgeInsets.only(right: 12.w),
        width: 70.w,
        child: Column(
          children: [
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: team.logo ??
                    'https://static.vecteezy.com/system/resources/previews/019/784/376/non_2x/people-icon-work-group-vector.jpg',
                width: 65.w,
                height: 65.h,
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: theme.colorScheme.secondary.withValues(alpha: 0.3),
                  highlightColor:
                      theme.colorScheme.secondary.withValues(alpha: 0.1),
                  child: Container(
                    width: 65.w,
                    height: 65.h,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            8.height,
            Text(
              '${team.name}',
              style: AppTextStyles.poppins12Regular(context)!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      ),
    );
  }
}
