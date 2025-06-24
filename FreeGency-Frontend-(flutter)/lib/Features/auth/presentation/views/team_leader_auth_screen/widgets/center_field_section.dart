import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/auth/presentation/view_model/cubits/validation_cubit/validation_cubit.dart';
import 'package:freegency_gp/Features/auth/presentation/views/team_leader_auth_screen/widgets/reusable_text_button.dart';
import 'package:freegency_gp/Features/auth/presentation/widgets/random_team_code_section.dart';
import 'package:freegency_gp/core/shared/widgets/custom_text_field.dart';

class CenterFieldsSection extends StatelessWidget {
  const CenterFieldsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ValidationCubit, ValidationState>(
      builder: (context, state) {
        return const Column(
          spacing: 16,
          children: [
            CustomTextField(
              label: 'Email',
              validationType: TextFieldValidation.EMAIL,
            ),
            CustomTextField(
              label: 'Password',
              isPassword: true,
              validationType: TextFieldValidation.PASSWORD,
            ),
            RandomCodeInputSection(),
            ReusableTextButton(
              text: 'Forgot random code or password ?',
            )
          ],
        );
      },
    );
  }
}
