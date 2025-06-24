import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';

class BuildErrorContent extends StatelessWidget {
  final String error;
  const BuildErrorContent({
    super.key,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 48.sp,
          ),
          SizedBox(height: 16.h),
          Text(
            error,
            style: AppTextStyles.poppins14Regular(context),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}