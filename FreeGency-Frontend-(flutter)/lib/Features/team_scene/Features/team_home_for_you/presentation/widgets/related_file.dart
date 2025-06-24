import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/data/models/task_model.dart';
import 'package:freegency_gp/core/shared/data/models/proposal_model.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

class RelatedFile extends StatelessWidget {
  final TaskModel? task;
  final ProposalModel? proposal;
  final String? similarProjectUrl;
  const RelatedFile.forTask({super.key, required this.task})
      : proposal = null,
        similarProjectUrl = null;
  const RelatedFile.forProposal({super.key, required this.proposal})
      : task = null,
        similarProjectUrl = null;
  const RelatedFile.forSimilarProject(
      {super.key, required this.similarProjectUrl})
      : task = null,
        proposal = null;

  @override
  Widget build(BuildContext context) {
    // Check if there are any files to display
    bool hasFiles = (task?.requirementFileUrl != null) ||
        (proposal?.proposalFiles?.isNotEmpty == true) ||
        (similarProjectUrl != null);

    if (!hasFiles) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ReusableTextStyleMethods.poppins14BoldMethod(
          context: context,
          text: task != null
              ? "Related files :"
              : proposal != null
                  ? "Similar project :"
                  : 'Other Links :',
        ),
        const SizedBox(height: 12),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: Theme.of(context).appBarTheme.backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Container(
                width: 38.w,
                height: 38.h,
                decoration: BoxDecoration(
                  color: Theme.of(context).appBarTheme.backgroundColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Icon(
                  similarProjectUrl != null ? Iconsax.link : Iconsax.document,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                    task != null
                        ? (task?.title ?? "Task file")
                        : proposal?.proposalFiles?.isNotEmpty == true
                            ? proposal!.proposalFiles!.first.fileName ??
                                "Proposal file"
                            : similarProjectUrl != null
                                ? "Similar Project"
                                : "No file name",
                    style: AppTextStyles.poppins14Regular(context)),
              ),
              IconButton(
                onPressed: () {
                  if (task?.requirementFileUrl != null) {
                    launchUrl(Uri.parse(task!.requirementFileUrl!));
                  } else if (proposal?.proposalFiles?.isNotEmpty == true &&
                      proposal!.proposalFiles!.first.fileUrl != null) {
                    launchUrl(
                        Uri.parse(proposal!.proposalFiles!.first.fileUrl!));
                  } else if (similarProjectUrl != null) {
                    launchUrl(Uri.parse(similarProjectUrl!));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('No file available to download'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                icon: Icon(
                  similarProjectUrl == null
                      ? Iconsax.document_download
                      : Iconsax.eye,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
