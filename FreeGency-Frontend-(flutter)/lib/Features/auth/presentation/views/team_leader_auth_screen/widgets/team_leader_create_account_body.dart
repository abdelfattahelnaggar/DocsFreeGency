import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/auth/data/models/teams_models/team_register_request_model.dart';
import 'package:freegency_gp/Features/auth/presentation/view_model/cubits/auth_cubit/teamLeader_auth_cubit/team_auth_cubit.dart';
import 'package:freegency_gp/Features/auth/presentation/view_model/cubits/auth_cubit/teamLeader_auth_cubit/team_auth_state.dart';
import 'package:freegency_gp/Features/auth/presentation/view_model/cubits/validation_cubit/validation_cubit.dart';
import 'package:freegency_gp/Features/auth/presentation/views/team_leader_auth_screen/widgets/create_account_footer.dart';
import 'package:freegency_gp/Features/auth/presentation/views/team_leader_auth_screen/widgets/leader_create_account_center_fields_section.dart';
import 'package:freegency_gp/Features/auth/presentation/widgets/top_welcome_message.dart';
import 'package:freegency_gp/core/utils/constants/routes.dart';
import 'package:get/get.dart';
import 'package:freegency_gp/core/shared/widgets/custom_snackbar.dart';
import 'package:freegency_gp/core/shared/widgets/app_loading_indicator.dart';

class TeamLeaderCreateAccountScreenBody extends StatelessWidget {
  const TeamLeaderCreateAccountScreenBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ValidationCubit>();
    return BlocConsumer<TeamAuthCubit, TeamAuthState>(
      listener: (context, state) {
        if (state is TeamAuthStateError) {
  showAppSnackBar(
    context,
    message: state.errMessage,
    type: SnackBarType.error,
  );
} else if (state is TeamAuthRegisterStateSuccess) {
  showAppSnackBar(
    context,
    message: 'Registration successful',
    type: SnackBarType.success,
  );
  Get.offAllNamed(AppRoutes.teamLogin);
}
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: Form(
            key: BlocProvider.of<ValidationCubit>(context).myForm,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  reverse: true,
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: Column(
                      spacing: 40,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const TopWelcomeMessage(
                          largeText:
                              'Register as a Team Leader\nand bring your team to new heights!',
                          descriptionText:
                              'Sign up to showcase your team\'s portfolio and connect with clients looking for expert services.',
                        ),
                        const LeaderCreateAccountCenterFieldsSection(),
                        CreateAccountFooter(
                          onLoginPressed: () {
                            if (cubit.validateForm()) {
                              context
                                  .read<TeamAuthCubit>()
                                  .teamCreateOrRegister(
                                    teamRegisterOrCreateRequestModel:
                                        TeamRegisterOrCreateRequestModel(
                                      name: cubit.emailController.text
                                          .split('@')[0],
                                      email: cubit.emailController.text,
                                      password: cubit.passwordController.text,
                                      confirmPassword:
                                          cubit.passwordController.text,
                                      teamName: cubit.nameController.text,
                                      category:
                                          cubit.teamCategoryController.text,
                                      teamCode: cubit.teamCodeController.text,
                                    ),
                                  );
                            }
                          },
                        ),
                        if (state is TeamAuthStateLoading)
                          const AppLoadingIndicator(size: 30),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
