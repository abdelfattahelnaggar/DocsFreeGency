import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/presentation/view_model/cubit/user_data_functionality_cubit.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/presentation/widgets/statistic_item.dart';
import 'package:freegency_gp/core/shared/widgets/app_loading_indicator.dart';

class StatisticsWithDataSection extends StatelessWidget {
  const StatisticsWithDataSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UserDataFunctionalityCubit>();

    return BlocBuilder<UserDataFunctionalityCubit, UserDataFunctionalityState>(
      builder: (context, state) {
        // Show loading indicator for initial loading
        if (state is UserDataFunctionalityInitial ||
            state is GetAllUserDataLoading ||
            state is GetUserDataSuccess ||
            state is GetMyTasksSuccess) {
          return const AppLoadingIndicator();
        }

        // Show loading indicator for error states
        if (state is GetAllUserDataError ||
            state is GetUserDataError ||
            state is GetMyTasksError) {
          return const Center(child: Text('Failed to load statistics'));
        }

        // Show cached data during image upload
        if (state is UploadImageLoading && cubit.hasTasksData) {
          final tasksData = cubit.cachedTasksData!;
          return _buildStatistics(
              tasksData.postedProjects.toString(),
              tasksData.projectsInProgress.toString(),
              tasksData.completedProjects.toString());
        }

        // Show data from successful states
        if (state is GetAllUserDataSuccess) {
          return _buildStatistics(
              state.tasksModel.postedProjects.toString(),
              state.tasksModel.projectsInProgress.toString(),
              state.tasksModel.completedProjects.toString());
        }

        // Show cached data if available
        if (cubit.hasTasksData) {
          final tasksData = cubit.cachedTasksData!;
          return _buildStatistics(
              tasksData.postedProjects.toString(),
              tasksData.projectsInProgress.toString(),
              tasksData.completedProjects.toString());
        }

        // Default loading state
        return const AppLoadingIndicator();
      },
    );
  }

  Widget _buildStatistics(String posted, String inProgress, String completed) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        StatisticItem(
          image: 'chart',
          label: 'Posted\nProjects',
          value: posted,
        ),
        StatisticItem(
          image: 'timer',
          label: 'Projects\ninProgress',
          value: inProgress,
        ),
        StatisticItem(
          image: 'like',
          label: 'Completed\nProjects',
          value: completed,
        ),
      ],
    );
  }
}
