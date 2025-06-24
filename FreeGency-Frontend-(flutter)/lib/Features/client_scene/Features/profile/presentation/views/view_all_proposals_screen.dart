import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/data/models/task_model.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/data/repositories/Tasks_Repo/implemented_tasks_repo.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/presentation/view_model/cubit/tasks_cubit/cubit/tasks_functionality_cubit.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/presentation/widgets/view_all_proposal_body.dart';
import 'package:freegency_gp/core/shared/data/repositories/proposal_repo/implemented_proposal_repo.dart';
import 'package:freegency_gp/core/shared/view_model/proposal_functionality/cubit/proposal_functionality_cubit.dart';
import 'package:get/get.dart';

class ViewAllProposalsScreen extends StatelessWidget {
  const ViewAllProposalsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final taskModel = ModalRoute.of(context)?.settings.arguments as TaskModel;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TasksFunctionalityCubit(ImplementTasksRepo())
            ..getTaskRequests(taskModel.id!),
        ),
        BlocProvider(
          create: (context) =>
              ProposalFunctionalityCubit(ImplementedProposalRepository()),
        ),
      ],
      child:
          BlocListener<ProposalFunctionalityCubit, ProposalFunctionalityState>(
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
            Future.delayed(const Duration(seconds: 2), () {
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
              ),
            );
          }
        },
        child: const ViewAllProposalsBody(),
      ),
    );
  }
}
