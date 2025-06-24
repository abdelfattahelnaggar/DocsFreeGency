import 'package:flutter/material.dart';
import 'package:freegency_gp/Features/home/presentation/views/client_home_page.dart';
import 'package:freegency_gp/core/shared/widgets/call_to_action_button.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:get/get.dart';

class ContinueAsGuestColumn extends StatelessWidget {
  const ContinueAsGuestColumn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      children: [
        ReusableTextStyleMethods.poppins14RegularMethod(
          context: context,
          text:
              'Searching for freelance opportunities? Explore open positions without signing up.',
        ),
        PrimaryCTAButton(
          label: 'Continue as a Guest',
          onTap: () {
            Get.offAllNamed(ClientHomePage.routeName);
          },
        ),
      ],
    );
  }
}
