import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/auth/presentation/view_model/cubits/auth_cubit/user_auth_cubit/user_auth_cubit.dart';
import 'package:freegency_gp/Features/auth/presentation/view_model/cubits/auth_cubit/user_auth_cubit/user_auth_state.dart';
import 'package:freegency_gp/Features/auth/presentation/view_model/cubits/validation_cubit/validation_cubit.dart';
import 'package:freegency_gp/Features/auth/presentation/views/otp_verification_screen.dart';
import 'package:freegency_gp/Features/auth/presentation/widgets/top_welcome_message.dart';
import 'package:freegency_gp/core/shared/widgets/custom_snackbar.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';
import 'package:freegency_gp/core/shared/widgets/call_to_action_button.dart';
import 'package:freegency_gp/core/shared/widgets/custom_text_field.dart';
import 'package:get/get.dart';

class ForgetPasswordScreenBody extends StatelessWidget {
  const ForgetPasswordScreenBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final validationCubit = context.read<ValidationCubit>();
    final authCubit = context.read<UserAuthCubit>();
    return BlocConsumer<UserAuthCubit, UserAuthStates>(
      listener: (context, state) {
        if (state is UserAuthForgetPasswordError) {
          // Show error message
          showAppSnackBar(
            context,
            message: state.errorMessage,
            type: SnackBarType.error,
          );
        } else if (state is UserAuthForgetPasswordSuccess) {
          Get.to( BlocProvider(
            create: (context) => UserAuthCubit(),
            child: const OtpVerificationScreen(),
          ),
                  arguments: validationCubit.emailController.text)
              ?.then((value) {
            validationCubit.myForm.currentState?.reset();
          });
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: validationCubit.myForm,
            child: Column(
              spacing: 30,
              children: [
                const TopWelcomeMessage(
                  largeText: 'Forgot Password',
                  descriptionText:
                      'Don\'t worry! It occurs. Please enter the email address linked with your account.',
                ),
                0.height,
                CustomTextField(
                  label: 'Email',
                  validationType: TextFieldValidation.EMAIL,
                  controller: validationCubit.emailController,
                ),
                PrimaryCTAButton(
                  onTap: () {
                    if (validationCubit.myForm.currentState?.validate() ??
                        false) {
                      authCubit
                          .forgetPassword(validationCubit.emailController.text);
                    }
                  },
                  label: 'Continue',
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
