import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/auth/presentation/view_model/cubits/validation_cubit/validation_cubit.dart';
import 'package:freegency_gp/Features/auth/presentation/views/team_leader_auth_screen/views/team_leader_create_account.dart';
import 'package:freegency_gp/Features/auth/presentation/views/team_leader_auth_screen/widgets/reusable_text_button.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:freegency_gp/core/shared/widgets/call_to_action_button.dart';
import 'package:get/get.dart' as getx;
import 'package:get/get.dart';

class AuthPageFooter extends StatelessWidget {
  const AuthPageFooter({
    super.key,
    required this.onLoginPressed,
  });

  final VoidCallback onLoginPressed;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ValidationCubit>();
    return Column(
      children: [
        PrimaryCTAButton(
          onTap: onLoginPressed,
          label: 'Login',
        ),
        24.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ReusableTextStyleMethods.poppins12RegularMethod(
                context: context,
                text: 'Agency or team don’t have an account? '),
            ReusableTextButton(
              onTap: () => Get.to(
                const TeamLeaderCreateAccount(),
                transition: getx.Transition.fadeIn,
                duration: const Duration(milliseconds: 800),
              )?.then((value) {
                cubit.myForm.currentState?.reset();
              }),
              text: 'create one',
            ),
          ],
        ),
        40.height
      ],
    );
  }
}
