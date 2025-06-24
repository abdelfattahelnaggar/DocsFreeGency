import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/data/models/task_model.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/presentation/view_model/cubit/tasks_cubit/cubit/tasks_functionality_cubit.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/presentation/widgets/header_task_details.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/presentation/widgets/proposal_card.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/presentation/widgets/proposal_shimmer_card.dart';
import 'package:freegency_gp/core/shared/widgets/custom_app_bar.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';

class ViewAllProposalsBody extends StatelessWidget {
  const ViewAllProposalsBody({super.key});

  @override
  Widget build(BuildContext context) {
    final taskModel = ModalRoute.of(context)?.settings.arguments as TaskModel;
    return Scaffold(
      appBar: CustomAppBar(
        isHome: false,
        child: ReusableTextStyleMethods.poppins16BoldMethod(
            context: context, text: 'Task Details'),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            HeaderTaskDetailsContainer(task: taskModel),
            16.height,
            BlocBuilder<TasksFunctionalityCubit, TasksFunctionalityState>(
              builder: (context, state) {
                if (state is GetTaskRequestsLoading) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      itemCount: 5,
                      separatorBuilder: (context, index) => 16.height,
                      itemBuilder: (context, index) =>
                          const ProposalShimmerCard(),
                    ),
                  );
                }

                if (state is GetTaskRequestsSuccess) {
                  if (state.taskRequests.pending.isEmpty) {
                    return const Center(
                      child: Text('No proposals found'),
                    );
                  }
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      itemCount: state.taskRequests.pending.length,
                      separatorBuilder: (context, index) => 16.height,
                      itemBuilder: (context, index) => ProposalCard(
                        teamRequest: state.taskRequests.pending[index],
                      ),
                    ),
                  );
                }

                if (state is GetTaskRequestsError) {
                  return Center(child: Text(state.errorMessage));
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}

