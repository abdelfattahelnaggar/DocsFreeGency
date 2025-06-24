import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freegency_gp/Features/auth/presentation/view_model/cubits/auth_cubit/user_auth_cubit/user_auth_cubit.dart';

class FilledOTPsTextFields extends StatelessWidget {
  const FilledOTPsTextFields({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return OtpTextField(
      numberOfFields: 6,
      filled: true,
      fillColor: Theme.of(context).colorScheme.primaryContainer,
      borderRadius: BorderRadius.circular(12),
      enabledBorderColor: Colors.transparent,
      disabledBorderColor: Colors.transparent,
      focusedBorderColor: Colors.transparent,
      borderColor: Colors.transparent,
      showFieldAsBox: true,
      autoFocus: true,
      borderWidth: 0,
      fieldWidth: 50.w,
      fieldHeight: 60.h,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      /* contentPadding:
          const EdgeInsets.symmetric(horizontal: 24, vertical: 16),*/
      decoration: InputDecoration(
        fillColor: Theme.of(context).colorScheme.primaryContainer,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      onSubmit: (String verificationCode) {
        // Handle the verification code here
        context.read<UserAuthCubit>().otpCode = verificationCode;
        log('Verification code: ${context.read<UserAuthCubit>().otpCode}');
      },
    );
  }
}
