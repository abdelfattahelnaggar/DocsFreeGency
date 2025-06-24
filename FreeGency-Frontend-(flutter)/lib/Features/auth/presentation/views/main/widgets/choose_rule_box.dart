import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:freegency_gp/Features/auth/data/models/guest_rule_model.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';

class ChooseRuleBox extends StatelessWidget {
  const ChooseRuleBox({
    super.key,
    this.onTap,
    required this.guestModel,
  });

  final VoidCallback? onTap;
  final GuestRuleModel guestModel;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          height: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
          child: Column(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                child: Image.asset(
                  guestModel.image,
                  fit: BoxFit.cover,
                ),
              ),
              ReusableTextStyleMethods.poppins16RegularMethod(
                context: context,
                text: context.tr(guestModel.text),
              ),
              Text(
                context.tr('${guestModel.text}_description'),
                style: AppTextStyles.poppins12Regular(context),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
