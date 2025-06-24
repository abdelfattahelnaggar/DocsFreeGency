import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/presentation/view_model/cubit/user_data_functionality_cubit.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/presentation/widgets/posted_task_card.dart';
import 'package:freegency_gp/core/shared/widgets/app_loading_indicator.dart';
import 'package:freegency_gp/core/utils/constants/routes.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';
import 'package:get/get.dart';

class TasksList extends StatelessWidget {
  const TasksList({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UserDataFunctionalityCubit>();

    return BlocBuilder<UserDataFunctionalityCubit, UserDataFunctionalityState>(
      builder: (context, state) {
        if (state is GetAllUserDataLoading) {
          return const AppLoadingIndicator();
        } else if (state is UploadImageLoading && cubit.hasTasksData) {
          final tasksData = cubit.cachedTasksData!;
          return _buildTasksList(tasksData.tasks);
        } else if (state is GetAllUserDataSuccess) {
          return _buildTasksList(state.tasksModel.tasks);
        } else if (state is GetAllUserDataError) {
          return Center(
            child: Text('Error: ${state.errorMessage}'),
          );
        } else if (cubit.hasTasksData) {
          return _buildTasksList(cubit.cachedTasksData!.tasks);
        } else if (state is GetMyTasksLoading) {
          return const AppLoadingIndicator();
        } else {
          // حالة التحميل
          return const AppLoadingIndicator();
        }
      },
    );
  }

  Widget _buildTasksList(final tasks) {
    if (tasks?.isEmpty ?? true) {
      return const Center(
        child: Text('No tasks found'),
      );
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return PostedTaskCard(
          project: tasks[index],
          onTap: () {
            Get.toNamed(AppRoutes.viewAllProposals, arguments: tasks[index]);
          },
        );
      },
      separatorBuilder: (context, index) => 16.height,
    );
  }
}
