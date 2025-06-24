import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/auth/presentation/view_model/cubits/validation_cubit/validation_cubit.dart';
import 'package:freegency_gp/Features/auth/presentation/widgets/password_checklist.dart';
import 'package:freegency_gp/core/shared/widgets/custom_text_field.dart';
import 'package:iconsax/iconsax.dart';

class ClientRegisterCenterFields extends StatelessWidget {
  const ClientRegisterCenterFields({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final validatorCubit = context.read<ValidationCubit>();

    return Column(
      spacing: 16,
      children: [
        CustomTextField(
          label: 'Name',
          prefixIcon: Iconsax.user,
          controller: validatorCubit.nameController,
        ),
        CustomTextField(
          label: 'Email',
          validationType: TextFieldValidation.EMAIL,
          controller: validatorCubit.emailController,
        ),
        CustomTextField(
          label: 'Password',
          isPassword: true,
          validationType: TextFieldValidation.PASSWORD,
          controller: validatorCubit.passwordController,
          onChanged: (password) {
            validatorCubit.onPasswordChanged(password);
          },
        ),
        const SizedBox(height: 8),
        const PasswordChecklist(),
      ],
    );
  }
}
