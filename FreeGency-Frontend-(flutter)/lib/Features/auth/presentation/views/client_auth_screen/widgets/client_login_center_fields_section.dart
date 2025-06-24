import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/auth/presentation/view_model/cubits/validation_cubit/validation_cubit.dart';
import 'package:freegency_gp/Features/auth/presentation/views/team_leader_auth_screen/widgets/reusable_text_button.dart';
import 'package:freegency_gp/core/shared/widgets/custom_text_field.dart';

class ClientLoginCenterFieldsSection extends StatelessWidget {
  const ClientLoginCenterFieldsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final validatorCubit = context.read<ValidationCubit>();

    return Column(
      spacing: 16,
      children: [
        CustomTextField(
          label: context.tr('email'),
          controller: validatorCubit.emailController,
        ),
        CustomTextField(
          label: context.tr('password'),
          isPassword: true,
          controller: validatorCubit.passwordController,
        ),
        ReusableTextButton(
          text: context.tr('forgot_password'),
        )
      ],
    );
  }
}
