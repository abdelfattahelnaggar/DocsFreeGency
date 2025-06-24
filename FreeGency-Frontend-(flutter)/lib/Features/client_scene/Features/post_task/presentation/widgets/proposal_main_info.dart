import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:freegency_gp/core/shared/data/models/proposal_model.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';
import 'package:iconsax/iconsax.dart';

class ProposalMainInfo extends StatelessWidget {
  final ProposalModel proposal;
  const ProposalMainInfo({super.key, required this.proposal});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Icon(
              Iconsax.clock4,
            ),
            8.width,
            Text(proposal.timeAgo,
                style: AppTextStyles.poppins12Regular(context)),
          ],
        ),
        16.height,
        Container(
          child: ReusableTextStyleMethods.poppins14RegularMethod(
              context: context,
              text: proposal.note ?? context.tr('no_description')),
        ),
      ],
    );
  }
}
