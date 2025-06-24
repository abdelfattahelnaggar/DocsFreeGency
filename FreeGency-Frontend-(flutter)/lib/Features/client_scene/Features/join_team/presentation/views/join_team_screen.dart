import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freegency_gp/Features/client_scene/Features/join_team/data/repositories/implement_join_team_repo.dart';
import 'package:freegency_gp/Features/client_scene/Features/join_team/presentation/view_model/cubit/join_team_cubit.dart';
import 'package:freegency_gp/Features/client_scene/Features/post_task/presentation/widgets/custom_text_field.dart';
import 'package:freegency_gp/core/shared/widgets/call_to_action_button.dart';
import 'package:freegency_gp/core/shared/widgets/custom_app_bar.dart';
import 'package:freegency_gp/core/shared/widgets/custom_snackbar.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';
import 'package:iconsax/iconsax.dart';

class JoinTeamScreen extends StatelessWidget {
  const JoinTeamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          JoinTeamCubit(joinTeamRepo: JoinTeamRepoImplementation()),
      child: Scaffold(
        appBar: const CustomAppBar(
          isHome: false,
          child: Text('Join Team'),
        ),
        body: BlocConsumer<JoinTeamCubit, JoinTeamState>(
          listener: (context, state) {
            if (state is JoinTeamSuccess) {
              showAppSnackBar(
                context,
                message: state.message,
                type: SnackBarType.success,
              );
              // Clear form and go back
              context.read<JoinTeamCubit>().clearForm();
              Navigator.of(context).pop();
            } else if (state is JoinTeamError) {
              showAppSnackBar(
                context,
                message: state.errorMessage,
                type: SnackBarType.error,
              );
            }
          },
          builder: (context, state) {
            final cubit = context.read<JoinTeamCubit>();

            return Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  30.h.height,
                  Center(
                    child: Icon(
                      Iconsax.people,
                      size: 80.w,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  30.h.height,
                  Text(
                    'Join a Team',
                    style: AppTextStyles.poppins24Bold(context),
                  ),
                  10.h.height,
                  Text(
                    'Enter the team code provided by the team leader to send a join request.',
                    style: AppTextStyles.poppins14Regular(context)?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.7),
                    ),
                  ),
                  40.h.height,
                  Text(
                    'Team Code',
                    style: AppTextStyles.poppins16Bold(context),
                  ),
                  10.h.height,
                  CustomTextField(
                    controller: cubit.teamCodeController,
                    hintText: 'Enter team code',
                    prefixIcon: Iconsax.code,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a team code';
                      }
                      return null;
                    },
                  ),
                  10.h.height,
                  Text(
                    'Job',
                    style: AppTextStyles.poppins16Bold(context),
                  ),
                  10.h.height,
                  CustomTextField(
                    controller: cubit.jobController,
                    hintText: 'Enter job',
                    prefixIcon: Iconsax.briefcase,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a job';
                      }
                      return null;
                    },
                  ),
                  10.h.height,
                  const Spacer(),
                  PrimaryCTAButton(
                    onTap: state is JoinTeamLoading
                        ? null
                        : () {
                            cubit.sendJoinRequest();
                          },
                    label: state is JoinTeamLoading
                        ? 'Sending Request...'
                        : 'Send Join Request',
                  ),
                  20.h.height,
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
