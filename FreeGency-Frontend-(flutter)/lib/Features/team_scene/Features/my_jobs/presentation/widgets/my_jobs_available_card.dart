import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/team_scene/Features/my_jobs/data/models/job_model.dart';
import 'package:freegency_gp/Features/team_scene/Features/my_jobs/presentation/view_model/cubits/my_jobs_cubit/my_jobs_cubit.dart';
import 'package:freegency_gp/Features/team_scene/Features/my_jobs/presentation/view_model/cubits/my_jobs_cubit/my_jobs_state.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';
import 'package:iconsax/iconsax.dart';

class MyJobsAvailableCard extends StatelessWidget {
  const MyJobsAvailableCard({
    super.key,
    required this.job,
    this.onTap,
  });

  final JobModel job;
  final VoidCallback? onTap;

  String formatLocation(String? skills) {
    if (skills == null || skills.isEmpty) {
      return 'Remote'; // Default location
    }
    return 'Skills: ${skills.length > 50 ? '${skills.substring(0, 50)}...' : skills}';
  }

  String formatSkills(List<String>? skills) {
    // For testing purposes, if no skills from API, show some demo skills
    if (skills == null || skills.isEmpty) {
      return 'No skills specified'; // Demo skills to show the format
    }

    if (skills.length == 1) {
      return skills[0];
    } else if (skills.length == 2) {
      return '${skills[0]}, ${skills[1]}';
    } else {
      // Show first 2 skills + dots
      return '${skills[0]}, ${skills[1]}...';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // Job Image/Logo
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: job.logoUrl.isNotEmpty
                  ? Image.network(
                      job.logoUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Iconsax.briefcase,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        );
                      },
                    )
                  : Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Iconsax.briefcase,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
            ),

            const SizedBox(width: 16),

            // Job Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Job Title
                  ReusableTextStyleMethods.poppins16BoldMethod(
                    context: context,
                    text: job.jobTitle,
                  ),

                  // Team Name
                  Text(
                    job.createdByTeam ?? 'Unknown Team',
                    style: AppTextStyles.poppins12Regular(context)!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface),
                  ),

                  4.height,

                  // Skills and Time Posted
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          formatSkills(job.requiredSkills),
                          style: AppTextStyles.poppins12Regular(context)!
                              .copyWith(fontSize: 10),
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                      Text(
                        ' | ',
                        style: AppTextStyles.poppins12Regular(context)!
                            .copyWith(fontSize: 10),
                      ),
                      Text(
                        job.getFormattedTime(),
                        style: AppTextStyles.poppins12Regular(context)!
                            .copyWith(
                                fontSize: 10, color: const Color(0xFF00C33B)),
                      ),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Delete Button
            BlocBuilder<MyJobsCubit, MyJobsState>(
              builder: (context, state) {
                bool isDeleting = state is DeleteJobLoading;
                return IconButton(
                  onPressed: isDeleting
                      ? null
                      : () {
                          _showDeleteDialog(context);
                        },
                  icon: isDeleting
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).colorScheme.error,
                            ),
                          ),
                        )
                      : Icon(
                          Iconsax.trash,
                          color: Theme.of(context).colorScheme.error,
                          size: 20,
                        ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: Text(
            'Delete Job',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
          content: Text(
            'Are you sure you want to delete "${job.jobTitle}"?',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                'Cancel',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onSurface),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<MyJobsCubit>().deleteJob(job.id);
              },
              child: Text(
                'Delete',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ],
        );
      },
    );
  }
}
