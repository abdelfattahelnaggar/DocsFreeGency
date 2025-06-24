import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/client_scene/Features/post_task/presentation/widgets/custom_text_field.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/presentation/view_model/cubit/user_data_functionality_cubit.dart';
import 'package:freegency_gp/core/shared/widgets/call_to_action_button.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';
import 'package:iconsax/iconsax.dart';

import 'section_card_widget.dart';

class AccountSettingsSection extends StatelessWidget {
  final TextEditingController currentPasswordController;
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final VoidCallback onChangePassword;

  const AccountSettingsSection({
    super.key,
    required this.currentPasswordController,
    required this.newPasswordController,
    required this.confirmPasswordController,
    required this.onChangePassword,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCardWidget(
      title: context.tr('edit_profile.account_settings'),
      children: [
        ReusableTextStyleMethods.poppins14BoldMethod(
            context: context,
            text: context.tr('edit_profile.current_password')),
        8.height,
        CustomTextField(
          fillColor: Theme.of(context).colorScheme.surface,
          controller: currentPasswordController,
          hintText: context.tr('edit_profile.current_password_hint'),
          prefixIcon: Iconsax.key,
          isPassword: true,
        ),
        16.height,
        ReusableTextStyleMethods.poppins14BoldMethod(
            context: context, text: context.tr('edit_profile.new_password')),
        8.height,
        CustomTextField(
          fillColor: Theme.of(context).colorScheme.surface,
          controller: newPasswordController,
          hintText: context.tr('edit_profile.new_password_hint'),
          prefixIcon: Iconsax.password_check,
          isPassword: true,
        ),
        16.height,
        ReusableTextStyleMethods.poppins14BoldMethod(
            context: context,
            text: context.tr('edit_profile.confirm_new_password')),
        8.height,
        CustomTextField(
          fillColor: Theme.of(context).colorScheme.surface,
          controller: confirmPasswordController,
          hintText: context.tr('edit_profile.confirm_new_password_hint'),
          prefixIcon: Iconsax.password_check,
          isPassword: true,
        ),
        24.height,
        BlocBuilder<UserDataFunctionalityCubit, UserDataFunctionalityState>(
          builder: (context, state) {
            final isChangingPassword = state is PasswordChanging;
            return PrimaryCTAButton(
              label: isChangingPassword
                  ? context.tr('changing')
                  : context.tr('change_password'),
              onTap: isChangingPassword ? null : onChangePassword,
              child: isChangingPassword
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : null,
            );
          },
        ),
        16.height,
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              // TODO: Navigate to forgot password flow
            },
            child: ReusableTextStyleMethods.poppins12RegularMethod(
                context: context,
                text: context.tr('edit_profile.forgot_password_question')),
          ),
        )
      ],
    );
  }
}
