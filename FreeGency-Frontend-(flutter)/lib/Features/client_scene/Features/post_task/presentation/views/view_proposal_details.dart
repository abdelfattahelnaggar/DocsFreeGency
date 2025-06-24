import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freegency_gp/Features/client_scene/Features/post_task/presentation/widgets/view_proposal_details_body.dart';
import 'package:freegency_gp/core/shared/data/repositories/proposal_repo/implemented_proposal_repo.dart';
import 'package:freegency_gp/core/shared/view_model/proposal_functionality/cubit/proposal_functionality_cubit.dart';
import 'package:get/get.dart';

class ViewProposalDetails extends StatelessWidget {
  const ViewProposalDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final proposalId = ModalRoute.of(context)?.settings.arguments as String?;
    return BlocProvider(
      create: (context) =>
          ProposalFunctionalityCubit(ImplementedProposalRepository())
            ..getProposalById(proposalId!),
      child:
          BlocListener<ProposalFunctionalityCubit, ProposalFunctionalityState>(
        listenWhen: (previous, current) =>
            current is AcceptTeamRequestSuccess ||
            current is AcceptTeamRequestError,
        listener: (context, state) {
          if (state is AcceptTeamRequestSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Proposal accepted successfully!'),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.all(8.r),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            );
            // Navigate back after a short delay
            Future.delayed(const Duration(milliseconds: 50), () {
              Get.back();
              Get.back();
            });
          }

          if (state is AcceptTeamRequestError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.errorMessage}'),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.all(8.r),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        child: const ViewProposalDetailsBody(),
      ),
    );
  }
}
