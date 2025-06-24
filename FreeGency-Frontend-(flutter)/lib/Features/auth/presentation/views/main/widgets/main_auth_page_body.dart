import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:freegency_gp/Features/auth/presentation/views/main/widgets/choose_rule_row.dart';
import 'package:freegency_gp/Features/auth/presentation/views/main/widgets/continue_as_guest_column.dart';
import 'package:freegency_gp/Features/auth/presentation/views/main/widgets/or_row.dart';
import 'package:freegency_gp/Features/auth/presentation/widgets/top_welcome_message.dart';
import 'package:freegency_gp/core/shared/widgets/freegency_app_logo.dart';

class MainAuthPageBody extends StatelessWidget {
  const MainAuthPageBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 24,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TopWelcomeMessage(
            hasBackIcon: false,
            largeText: context.tr('welcome_title'),
            descriptionText: context.tr('welcome_description'),
          ),
          const FreeGencyLogo(),
          const ContinueAsGuestColumn(),
          const OrRow(),
          const ChooseRuleRow(),
        ],
      ),
    );
  }
}
