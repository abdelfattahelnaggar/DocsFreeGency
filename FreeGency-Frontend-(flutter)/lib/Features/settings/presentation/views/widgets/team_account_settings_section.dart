import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/client_scene/Features/post_task/presentation/widgets/custom_text_field.dart';
import 'package:freegency_gp/core/shared/widgets/call_to_action_button.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';
import 'package:iconsax/iconsax.dart';

import '../../cubit/team_profile_cubit.dart';
import '../../cubit/team_profile_state.dart';
import 'section_card_widget.dart';

class TeamAccountSettingsSection extends StatelessWidget {
  final TextEditingController currentPasswordController;
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final VoidCallback onChangePassword;
  final VoidCallback onManageTeamMembers;
  final VoidCallback onPaymentMethods;

  const TeamAccountSettingsSection({
    super.key,
    required this.currentPasswordController,
    required this.newPasswordController,
    required this.confirmPasswordController,
    required this.onChangePassword,
    required this.onManageTeamMembers,
    required this.onPaymentMethods,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCardWidget(
      title: context.tr('edit_profile.team_account_settings'),
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Iconsax.user_add),
          title: ReusableTextStyleMethods.poppins14RegularMethod(
              context: context,
              text: context.tr('edit_profile.manage_team_members')),
          trailing: const Icon(Iconsax.arrow_right_3),
          onTap: onManageTeamMembers,
        ),
        const Divider(),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Iconsax.card),
          title: ReusableTextStyleMethods.poppins14RegularMethod(
              context: context,
              text: context.tr('edit_profile.payment_methods')),
          trailing: const Icon(Iconsax.arrow_right_3),
          onTap: onPaymentMethods,
        ),
        const Divider(),
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
        BlocBuilder<TeamProfileCubit, TeamProfileState>(
          builder: (context, state) {
            final isChangingPassword = state is TeamPasswordChanging;
            return PrimaryCTAButton(
              label: isChangingPassword
                  ? 'Changing...'
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
