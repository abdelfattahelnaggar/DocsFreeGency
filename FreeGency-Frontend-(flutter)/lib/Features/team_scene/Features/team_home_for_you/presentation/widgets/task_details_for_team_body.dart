import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/presentation/view_model/cubit/tasks_cubit/cubit/tasks_functionality_cubit.dart';
import 'package:freegency_gp/Features/team_scene/Features/team_home_for_you/presentation/views/create_proposal_screen.dart';
import 'package:freegency_gp/Features/team_scene/Features/team_home_for_you/presentation/widgets/related_file.dart';
import 'package:freegency_gp/Features/team_scene/Features/team_home_for_you/presentation/widgets/required_skills.dart';
import 'package:freegency_gp/Features/team_scene/Features/team_home_for_you/presentation/widgets/task_creator_header.dart';
import 'package:freegency_gp/Features/team_scene/Features/team_home_for_you/presentation/widgets/task_main_info.dart';
import 'package:freegency_gp/core/shared/widgets/app_loading_indicator.dart';
import 'package:freegency_gp/core/shared/widgets/call_to_action_button.dart';
import 'package:freegency_gp/core/shared/widgets/custom_app_bar.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';

class TaskDetailsForTeamBody extends StatelessWidget {
  const TaskDetailsForTeamBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        isHome: false,
        child: ReusableTextStyleMethods.poppins16BoldMethod(
            context: context, text: 'Task Details'),
      ),
      bottomSheet: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).appBarTheme.backgroundColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16.r),
            bottomRight: Radius.circular(16.r),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: PrimaryCTAButton(
            label: "Send Proposal",
            onTap: () {
              // Get the current task from the state
              final state = context.read<TasksFunctionalityCubit>().state;
              if (state is GetTaskByIdSuccess) {
                // Navigate to create proposal screen with the task
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CreateProposalScreen(task: state.task),
                  ),
                );
              }
            },
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: BlocBuilder<TasksFunctionalityCubit, TasksFunctionalityState>(
            builder: (context, state) {
              if (state is GetTaskByIdLoading) {
                return const AppLoadingIndicator();
              } else if (state is GetTaskByIdError) {
                return Center(child: Text(state.errorMessage));
              } else if (state is GetTaskByIdSuccess) {
                final task = state.task;
                return Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h)
                          .copyWith(bottom: 100.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TaskCreatorHeader(
                        imageUrl: task.clientProfileImage,
                        name: task.clientName,
                        taskId: task.id,
                      ),
                      TaskMainInfo(task: task),
                      16.height,
                      RelatedFile.forTask(task: task),
                      16.height,
                      RequiredSkills(task: task),
                      16.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ReusableTextStyleMethods.poppins14BoldMethod(
                            context: context,
                            text: "Deadline : \n${task.deadlineTimeAgo}",
                          ),
                          ReusableTextStyleMethods.poppins14BoldMethod(
                            context: context,
                            text:
                                "Client Budget : \n${task.budget} ${task.isFixedPrice! ? 'Fixed Price' : 'Changeable'}",
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
