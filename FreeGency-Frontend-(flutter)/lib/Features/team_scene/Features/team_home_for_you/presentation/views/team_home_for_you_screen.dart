import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freegency_gp/Features/client_scene/Features/post_task/presentation/widgets/custom_text_field.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/data/models/task_model.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/presentation/widgets/posted_task_card.dart';
import 'package:freegency_gp/Features/team_scene/Features/team_home_for_you/data/repositories/implement_team_home_repo.dart';
import 'package:freegency_gp/Features/team_scene/Features/team_home_for_you/presentation/view_model/cubit/my_team_functionality_cubit_cubit.dart';
import 'package:freegency_gp/Features/team_scene/Features/team_home_for_you/presentation/widgets/shimmer_list_of_tasks.dart';
import 'package:freegency_gp/core/utils/constants/routes.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TeamHomeForYouScreen extends StatefulWidget {
  const TeamHomeForYouScreen({super.key});

  @override
  State<TeamHomeForYouScreen> createState() => _TeamHomeForYouScreenState();
}

class _TeamHomeForYouScreenState extends State<TeamHomeForYouScreen> {
  int selectedIndex = 0;

  final List<String> titles = ['Best Matches', 'Saved Jobs'];
  final List<IconData> icons = [Iconsax.lamp_on, Icons.bookmark_outline];

  late MyTeamFunctionalityCubitCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = MyTeamFunctionalityCubitCubit(
      teamHomeRepo: TeamHomeRepoImplementation(),
    );
    _loadTasks();
  }

  void _loadTasks() {
    if (selectedIndex == 0) {
      _cubit.getBestMatchesTasks();
    } else {
      _cubit.getSavedTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: ListView(
          children: [
            const CustomTextField(
              hintText: 'search a task',
              controller: null,
              prefixIcon: Iconsax.search_normal,
            ).paddingSymmetric(horizontal: 24.w, vertical: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(titles.length, (index) {
                  final isSelected = selectedIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                      _loadTasks();
                    },
                    child: Container(
                      height: 125.h,
                      width: 125.w,
                      padding: EdgeInsets.symmetric(
                          horizontal: 32.w, vertical: 16.h),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context)
                                .colorScheme
                                .primary
                                .withValues(alpha: 0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            icons[index],
                            size: 40,
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            titles[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
            20.h.height,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: BlocBuilder<MyTeamFunctionalityCubitCubit,
                  MyTeamFunctionalityCubitState>(
                builder: (context, state) {
                  if (state is MyTeamFunctionalityCubitLoading) {
                    return const ShimmerListOfTasks();
                  } else if (state is MyTeamFunctionalityCubitSuccess) {
                    return _buildTasksList(state.tasks);
                  } else if (state is MyTeamFunctionalityCubitError) {
                    return Center(
                      child: Text('Error: ${state.errorMessage}'),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTasksList(List<TaskModel> tasks) {
    if (tasks.isEmpty) {
      return Center(
        child:
            Text('No ${selectedIndex == 0 ? "matching" : "saved"} tasks found'),
      );
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return PostedTaskCard(
          project: tasks[index],
          isTeam: true,
          onTap: () {
            Get.toNamed(AppRoutes.taskDetailsForTeam,
                arguments: tasks[index].id);
          },
        );
      },
      separatorBuilder: (context, index) => 16.height,
    );
  }
}
