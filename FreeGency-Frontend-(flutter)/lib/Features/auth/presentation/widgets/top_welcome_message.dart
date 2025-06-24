import 'package:flutter/material.dart';
import 'package:freegency_gp/Features/auth/presentation/widgets/header_message_icon.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';

class TopWelcomeMessage extends StatelessWidget {
  const TopWelcomeMessage({
    super.key,
    required this.largeText,
    required this.descriptionText,
    this.hasBackIcon = true,
  });

  final String largeText;
  final String descriptionText;
  final bool? hasBackIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: Column(
        spacing: 16,
        children: [
          if (hasBackIcon!) const HeaderMessageIcon() else const SizedBox(),
          Text(
            largeText,
            style: AppTextStyles.poppins20Bold(context),
            textAlign: TextAlign.center,
          ),
          Text(
            descriptionText,
            style: AppTextStyles.poppins14Regular(context),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
