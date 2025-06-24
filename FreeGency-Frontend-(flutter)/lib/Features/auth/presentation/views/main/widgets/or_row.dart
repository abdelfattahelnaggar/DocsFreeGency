import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';

class OrRow extends StatelessWidget {
  const OrRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        const Expanded(child: Divider()),
        ReusableTextStyleMethods.poppins16RegularMethod(
          context: context,
          text: context.tr('user_type_selection'),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}
