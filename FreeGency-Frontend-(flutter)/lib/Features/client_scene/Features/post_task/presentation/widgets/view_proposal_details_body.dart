import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freegency_gp/Features/client_scene/Features/post_task/presentation/widgets/proposal_creator_header.dart';
import 'package:freegency_gp/Features/client_scene/Features/post_task/presentation/widgets/proposal_main_info.dart';
import 'package:freegency_gp/Features/team_scene/Features/team_home_for_you/presentation/widgets/related_file.dart';
import 'package:freegency_gp/core/shared/data/models/proposal_model.dart';
import 'package:freegency_gp/core/shared/view_model/proposal_functionality/cubit/proposal_functionality_cubit.dart';
import 'package:freegency_gp/core/shared/widgets/app_loading_indicator.dart';
import 'package:freegency_gp/core/shared/widgets/call_to_action_button.dart';
import 'package:freegency_gp/core/shared/widgets/custom_app_bar.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';

class ViewProposalDetailsBody extends StatelessWidget {
  const ViewProposalDetailsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        isHome: false,
        child: ReusableTextStyleMethods.poppins16BoldMethod(
            context: context, text: 'Proposal Details'),
      ),
      bottomSheet:
          BlocBuilder<ProposalFunctionalityCubit, ProposalFunctionalityState>(
        builder: (context, state) {
          final isLoading = state is AcceptTeamRequestLoading;

          // Get proposal data regardless of state
          ProposalModel? proposal;
          if (state is GetProposalByIdSuccess) {
            proposal = state.proposal;
          } else if ((state is AcceptTeamRequestLoading ||
                  state is AcceptTeamRequestError) &&
              context.read<ProposalFunctionalityCubit>().lastProposal != null) {
            proposal = context.read<ProposalFunctionalityCubit>().lastProposal;
          }

          if (state is GetProposalByIdLoading || proposal == null) {
            return Container(
              height: 80.h,
              decoration: BoxDecoration(
                color: Theme.of(context).appBarTheme.backgroundColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16.r),
                  bottomRight: Radius.circular(16.r),
                ),
              ),
            );
          }

          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).appBarTheme.backgroundColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16.r),
                bottomRight: Radius.circular(16.r),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: isLoading
                  ? SizedBox(
                      height: 48.h,
                      child: const Center(
                        child: AppLoadingIndicator(),
                      ),
                    )
                  : PrimaryCTAButton(
                      label: "Accept Proposal",
                      onTap: () {
                        context
                            .read<ProposalFunctionalityCubit>()
                            .acceptTeamRequest(proposal!.id!);
                      },
                    ),
            ),
          );
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: BlocBuilder<ProposalFunctionalityCubit,
              ProposalFunctionalityState>(
            builder: (context, state) {
              if (state is GetProposalByIdLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is GetProposalByIdError) {
                return Center(child: Text(state.errorMessage));
              }

              // Get proposal data even if we're in loading, error or success state
              ProposalModel? proposal;
              if (state is GetProposalByIdSuccess) {
                proposal = state.proposal;
                // Store the proposal for access during other states
                context.read<ProposalFunctionalityCubit>().lastProposal =
                    proposal;
              } else if ((state is AcceptTeamRequestLoading ||
                      state is AcceptTeamRequestError ||
                      state is AcceptTeamRequestSuccess) &&
                  context.read<ProposalFunctionalityCubit>().lastProposal !=
                      null) {
                proposal =
                    context.read<ProposalFunctionalityCubit>().lastProposal;
              }

              if (proposal == null) {
                return const SizedBox.shrink();
              }

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h)
                    .copyWith(bottom: 100.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProposalCreatorHeader(
                      imageUrl: proposal.teamLogo,
                      name: proposal.teamName,
                    ),
                    16.height,
                    ProposalMainInfo(proposal: proposal),
                    16.height,
                    RelatedFile.forProposal(proposal: proposal),
                    16.height,
                    RelatedFile.forSimilarProject(
                        similarProjectUrl: proposal.similarProjectUrl),
                    16.height,
                    proposal.budget != null
                        ? ReusableTextStyleMethods.poppins14BoldMethod(
                            context: context,
                            text: "Budget : \n${proposal.budget}",
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
