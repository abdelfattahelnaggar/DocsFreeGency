import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/auth/presentation/view_model/cubits/auth_cubit/user_auth_cubit/user_auth_cubit.dart';
import 'package:freegency_gp/Features/auth/presentation/view_model/cubits/auth_cubit/user_auth_cubit/user_auth_state.dart';
import 'package:freegency_gp/Features/auth/presentation/views/team_leader_auth_screen/widgets/reusable_text_button.dart';
import 'package:freegency_gp/Features/auth/presentation/widgets/filled_otps_text_fields.dart';
import 'package:freegency_gp/Features/auth/presentation/widgets/top_welcome_message.dart';
import 'package:freegency_gp/core/utils/constants/routes.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:freegency_gp/core/shared/widgets/call_to_action_button.dart';
import 'package:get/get.dart';
import 'package:freegency_gp/core/shared/widgets/custom_snackbar.dart';

class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<UserAuthCubit>();
    final email = ModalRoute.of(context)?.settings.arguments as String;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const TopWelcomeMessage(
                    largeText: 'OTP verification',
                    descriptionText:
                        'Enter the verification code we just sent on your email address.',
                  ),
                  const SizedBox(height: 60),
                  Column(
                    children: [
                      const FilledOTPsTextFields(),
                      const SizedBox(height: 24),
                      BlocListener<UserAuthCubit, UserAuthStates>(
                        listener: (context, state) {
                         if (state is UserAuthVerifyEmailError) {
  showAppSnackBar(
    context,
    message: state.errorMessage,
    type: SnackBarType.error,
    actionLabel: 'Close',
    onAction: () {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    },
  );
} else if (state is UserAuthVerifyEmailSuccess) {
  showAppSnackBar(
    context,
    message: 'Verification successful',
    type: SnackBarType.success,
    actionLabel: 'Reset',
    onAction: () {
      Get.toNamed(AppRoutes.resetPassword);
    },
  );
}
                        },
                        child: BlocBuilder<UserAuthCubit, UserAuthStates>(
                          builder: (context, state) {
                            return PrimaryCTAButton(
                              label: state is UserAuthVerifyEmailLoading
                                  ? 'Loading...'
                                  : 'Verify',
                              onTap: () {
                                if (authCubit.otpCode != null) {
                                  authCubit.verifyEmail(authCubit.otpCode!);
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ReusableTextStyleMethods.poppins12RegularMethod(
                      context: context, text: 'Don\'t receive code? '),
                  BlocListener<UserAuthCubit, UserAuthStates>(
                    listener: (context, state) {
                      if (state is UserAuthForgetPasswordSuccess) {
  showAppSnackBar(
    context,
    message: 'OTP code sent successfully',
    type: SnackBarType.success,
  );
} else if (state is UserAuthForgetPasswordError) {
  showAppSnackBar(
    context,
    message: state.errorMessage,
    type: SnackBarType.error,
  );
}
                    },
                    child: ReusableTextButton(
                      onTap: () {
                        authCubit.forgetPassword(email);
                      },
                      text: 'resend',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
