import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/auth/presentation/view_model/cubits/auth_cubit/user_auth_cubit/user_auth_cubit.dart';
import 'package:freegency_gp/Features/auth/presentation/view_model/cubits/auth_cubit/user_auth_cubit/user_auth_state.dart';
import 'package:freegency_gp/Features/auth/presentation/view_model/cubits/validation_cubit/validation_cubit.dart';
import 'package:freegency_gp/Features/auth/presentation/widgets/password_checklist.dart';
import 'package:freegency_gp/Features/auth/presentation/widgets/top_welcome_message.dart';
import 'package:freegency_gp/core/shared/widgets/call_to_action_button.dart';
import 'package:freegency_gp/core/shared/widgets/custom_snackbar.dart';
import 'package:freegency_gp/core/shared/widgets/custom_text_field.dart';
import 'package:freegency_gp/core/utils/constants/routes.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';
import 'package:get/get.dart';

class ResetPasswordBody extends StatelessWidget {
  const ResetPasswordBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final validationCubit = context.read<ValidationCubit>();
    final authCubit = context.read<UserAuthCubit>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Form(
        key: validationCubit.myForm,
        child: Column(
          spacing: 30,
          children: [
            const TopWelcomeMessage(
              largeText: 'Create New Password',
              descriptionText:
                  'Your new password must be unique from those previously used.',
            ),
            0.height,
            CustomTextField(
              label: 'Email',
              validationType: TextFieldValidation.EMAIL,
              controller: validationCubit.emailController,
            ),
            CustomTextField(
              label: 'New Password',
              validationType: TextFieldValidation.PASSWORD,
              controller: validationCubit.passwordController,
              isPassword: true,
              onChanged: (password) {
                validationCubit.onPasswordChanged(password);
              },
            ),
            const PasswordChecklist(),
            BlocConsumer<UserAuthCubit, UserAuthStates>(
              listener: (context, state) {
                if (state is UserAuthResetPasswordSuccess) {
                  showAppSnackBar(
                    context,
                    message: 'Password reset successfully',
                    type: SnackBarType.success,
                  );
                  Get.offAllNamed(AppRoutes.userLogin);
                }
                if (state is UserAuthResetPasswordError) {
                  showAppSnackBar(
                    context,
                    message: state.errorMessage,
                    type: SnackBarType.error,
                    actionLabel: 'Close',
                    onAction: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    },
                  );
                }
              },
              builder: (context, state) {
                return PrimaryCTAButton(
                  onTap: () {
                    if (validationCubit.myForm.currentState?.validate() ??
                        false) {
                      authCubit.resetPassword(
                        email: validationCubit.emailController.text,
                        newPassword: validationCubit.passwordController.text,
                      );
                    }
                  },
                  label: state is UserAuthResetPasswordLoading
                      ? 'Loading...'
                      : 'Reset Password',
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
