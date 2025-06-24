import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/presentation/view_model/team_task_management_cubit.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';
import 'package:get/get.dart';

class BodyInErrorState extends StatelessWidget {
  const BodyInErrorState({
    super.key,
    required this.errorMessage,
  });

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height - 100,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: context.theme.colorScheme.error,
              ),
              16.height,
              ReusableTextStyleMethods.poppins16RegularMethod(
                context: context,
                text: 'Error loading tasks',
              ),
              8.height,
              Text(
                errorMessage,
                style: context.theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              16.height,
              ElevatedButton(
                onPressed: () {
                  context
                      .read<TeamTaskManagementCubit>()
                      .getTeamTasks();
                },
                child: const Text('Retry'),
              ),
              8.height,
              Text(
                'Pull down to refresh',
                style: context.theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
