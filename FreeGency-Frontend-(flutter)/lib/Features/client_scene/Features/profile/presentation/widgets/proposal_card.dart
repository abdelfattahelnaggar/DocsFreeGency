import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/data/models/task_request_model.dart';
import 'package:freegency_gp/core/shared/view_model/proposal_functionality/cubit/proposal_functionality_cubit.dart';
import 'package:freegency_gp/core/utils/constants/routes.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';
import 'package:get/get.dart';

class ProposalCard extends StatelessWidget {
  final TeamRequestModel teamRequest;
  const ProposalCard({
    super.key,
    required this.teamRequest,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProposalFunctionalityCubit, ProposalFunctionalityState>(
      builder: (context, state) {
        final bool isLoading = state is AcceptTeamRequestLoading;
        final bool isCurrentCardLoading =
            isLoading && (state).teamRequestId == teamRequest.id;
        final bool shouldBlur = isLoading && !isCurrentCardLoading;

        return AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: shouldBlur ? 0.5 : 1.0,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      ReusableTextStyleMethods.poppins14BoldMethod(
                        context: context,
                        text: teamRequest.teamName ?? '',
                      ),
                      const Spacer(),
                      ReusableTextStyleMethods.poppins12RegularMethod(
                        context: context,
                        text: teamRequest.timeAgo,
                      ),
                    ],
                  ),
                  8.height,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ReusableTextStyleMethods.poppins20BoldMethod(
                              context: context,
                              text: teamRequest.teamName ?? '',
                            ),
                            8.height,
                            Text(
                              teamRequest.note!,
                              style: AppTextStyles.poppins14Regular(context),
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                            8.height,
                            Text(
                              'Budget: ${teamRequest.budget!.toInt()} USD',
                              style: AppTextStyles.poppins12Regular(context),
                            ),
                          ],
                        ),
                      ),
                      8.width,
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          width: 94.w,
                          height: 98.h,
                          child: CachedNetworkImage(
                            imageUrl: teamRequest.teamLogo ??
                                'https://th.bing.com/th/id/OIP.IGNf7GuQaCqz_RPq5wCkPgHaLH?rs=1&pid=ImgDetMain',
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                    ],
                  ),
                  8.height,
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: shouldBlur
                              ? null
                              : () {
                                  Get.toNamed(AppRoutes.viewProposalDetails,
                                      arguments: teamRequest.id);
                                },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.visibility,
                                size: 16,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'View Proposal',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      8.width,
                      Expanded(
                        child: SizedBox(
                          height: 44.h,
                          child: ElevatedButton(
                            onPressed: shouldBlur || isCurrentCardLoading
                                ? null
                                : () {
                                    context
                                        .read<ProposalFunctionalityCubit>()
                                        .acceptTeamRequest(teamRequest.id!);
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: isCurrentCardLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Accept',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
