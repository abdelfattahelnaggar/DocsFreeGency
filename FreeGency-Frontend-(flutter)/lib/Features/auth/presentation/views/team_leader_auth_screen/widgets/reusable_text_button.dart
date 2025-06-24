import 'package:flutter/material.dart';
import 'package:freegency_gp/Features/auth/presentation/views/forget_password_verification.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';
import 'package:get/get.dart' as getx;
import 'package:get/get.dart';

class ReusableTextButton extends StatelessWidget {
  const ReusableTextButton({
    super.key,
    required this.text,
    this.onTap,
  });

  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: onTap ??
              () => Get.to(
                    const ForgetPasswordVerificationPage(),
                  ),
          style: ButtonStyle(
            padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero),
            overlayColor: WidgetStateProperty.all<Color>(Colors.transparent),
            minimumSize: WidgetStateProperty.all<Size>(Size.zero),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            text,
            style: AppTextStyles.poppins12Regular(context)!.copyWith(
              color: const Color(0xff5482FF),
            ),
          ),
        ),
      ],
    );
  }
}
