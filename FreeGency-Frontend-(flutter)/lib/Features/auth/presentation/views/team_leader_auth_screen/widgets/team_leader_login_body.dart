import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/auth/data/models/client_models/user_login_request_model.dart';
import 'package:freegency_gp/Features/auth/presentation/view_model/cubits/auth_cubit/teamLeader_auth_cubit/team_auth_cubit.dart';
import 'package:freegency_gp/Features/auth/presentation/view_model/cubits/auth_cubit/teamLeader_auth_cubit/team_auth_state.dart';
import 'package:freegency_gp/Features/auth/presentation/view_model/cubits/validation_cubit/validation_cubit.dart';
import 'package:freegency_gp/Features/auth/presentation/views/team_leader_auth_screen/widgets/leader_login_center_field_section.dart';
import 'package:freegency_gp/Features/auth/presentation/widgets/top_welcome_message.dart';
import 'package:freegency_gp/core/shared/widgets/app_loading_indicator.dart';
import 'package:freegency_gp/core/shared/widgets/custom_snackbar.dart';
import 'package:freegency_gp/core/utils/constants/routes.dart';
import 'package:get/get.dart';

import 'auth_page_footer.dart';

class TeamLeaderLoginScreenBody extends StatefulWidget {
  const TeamLeaderLoginScreenBody({
    super.key,
  });

  @override
  State<TeamLeaderLoginScreenBody> createState() =>
      _TeamLeaderLoginScreenBodyState();
}

class _TeamLeaderLoginScreenBodyState extends State<TeamLeaderLoginScreenBody> {
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
        } else if (state is TeamAuthStateSuccess) {
          Get.offAllNamed(AppRoutes.clientHome);
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: Form(
            key: cubit.myForm,
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
                          largeText: 'Welcome Back, Leader!',
                          descriptionText:
                              'Ready to manage your team and projects?\nLog in to oversee tasks, communicate with clients, and guide your team.',
                        ),
                        const LeaderLoginCenterFieldsSection(),
                        AuthPageFooter(
                          onLoginPressed: () {
                            if (cubit.validateForm()) {
                              context.read<TeamAuthCubit>().teamLogin(
                                    userLoginRequest: UserLoginRequestModel(
                                      email: cubit.emailController.text,
                                      password: cubit.passwordController.text,
                                    ),
                                  );
                            }
                          },
                        ),
                        if (state is TeamAuthStateLoading)
                          const AppLoadingIndicator(),
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
