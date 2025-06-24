import 'package:flutter/material.dart';
import 'package:freegency_gp/Features/auth/presentation/views/team_leader_auth_screen/widgets/reusable_text_button.dart';
import 'package:freegency_gp/core/shared/widgets/call_to_action_button.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';
import 'package:get/get.dart';

class CreateAccountFooter extends StatelessWidget {
  const CreateAccountFooter({
    super.key,
    required this.onLoginPressed,
  });
  final VoidCallback onLoginPressed;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PrimaryCTAButton(
          onTap: onLoginPressed,
          label: 'Create account',
        ),
        24.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ReusableTextStyleMethods.poppins12RegularMethod(
                context: context,
                text: 'Agency or team already have an account? '),
            ReusableTextButton(
              onTap: () => Get.back(),
              text: 'Login',
            ),
          ],
        ),
        40.height
      ],
    );
  }
}
