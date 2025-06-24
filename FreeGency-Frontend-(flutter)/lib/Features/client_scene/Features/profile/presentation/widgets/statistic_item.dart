import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';


class StatisticItem extends StatelessWidget {
  final String? image;
  final String? label;
  final String? value;
  const StatisticItem({super.key, this.image, this.label, this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset('assets/icons/$image.svg'),
        8.h.height,
        Text(
          value ?? '',
          style: AppTextStyles.poppins14Regular(context)!.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        4.height,
        Text(
          textAlign: TextAlign.center,
          label ?? '',
          style: AppTextStyles.poppins14Regular(context)!.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
