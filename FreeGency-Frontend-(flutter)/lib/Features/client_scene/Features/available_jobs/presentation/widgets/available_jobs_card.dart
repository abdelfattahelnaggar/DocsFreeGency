import 'package:flutter/material.dart';
import 'package:freegency_gp/Features/team_scene/Features/my_jobs/data/models/job_model.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';

class AvailableJobsCard extends StatelessWidget {
  const AvailableJobsCard({
    super.key,
    required this.job,
  });

  final JobModel job;

  String formatLocation(String location) {
    if (location.toLowerCase().startsWith('remote')) {
      return '${location.replaceFirst('Remote – ', '')} (Remote)';
    } else if (location.toLowerCase().startsWith('hybrid')) {
      return '${location.replaceFirst('Hybrid – ', '')} (Hybrid)';
    }
    return location;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        spacing: 16,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              job.logoUrl.isNotEmpty
                  ? job.logoUrl
                  : 'https://static.vecteezy.com/system/resources/previews/039/845/042/non_2x/male-default-avatar-profile-gray-picture-grey-photo-placeholder-gray-profile-anonymous-face-picture-illustration-isolated-on-white-background-free-vector.jpg',
              width: 50,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.business, color: Colors.grey),
                );
              },
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReusableTextStyleMethods.poppins16BoldMethod(
                  context: context,
                  text: job.jobTitle,
                ),
                Text(
                  job.createdByTeam ?? 'Unknown Company',
                  style: AppTextStyles.poppins12Regular(context)!
                      .copyWith(color: Theme.of(context).colorScheme.onSurface),
                ),
                4.height,
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        job.getFormattedTime(),
                        style: AppTextStyles.poppins12Regular(context)!
                            .copyWith(
                                fontSize: 10, color: const Color(0xFF00C33B)),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
