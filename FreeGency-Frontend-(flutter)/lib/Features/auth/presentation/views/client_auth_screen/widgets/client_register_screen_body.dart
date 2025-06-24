import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/auth/data/models/client_models/user_register_request.dart';
import 'package:freegency_gp/Features/auth/presentation/view_model/cubits/auth_cubit/user_auth_cubit/user_auth_cubit.dart';
import 'package:freegency_gp/Features/auth/presentation/view_model/cubits/validation_cubit/validation_cubit.dart';
import 'package:freegency_gp/Features/auth/presentation/views/client_auth_screen/widgets/client_auth_footer.dart';
import 'package:freegency_gp/Features/auth/presentation/views/client_auth_screen/widgets/client_register_centered_forms.dart';
import 'package:freegency_gp/Features/auth/presentation/widgets/top_welcome_message.dart';

class ClientRegisterScreenBody extends StatelessWidget {
  const ClientRegisterScreenBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final validateCubit = context.read<ValidationCubit>();
    final authCubit = context.read<UserAuthCubit>();
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: Form(
          key: validateCubit.myForm,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                reverse: true,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    spacing: 60,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const TopWelcomeMessage(
                        largeText:
                            'Join and find the perfect team for your next big idea!',
                        descriptionText:
                            'Sign up to connect with top agencies and teams ready to bring your vision to life.',
                      ),
                      const ClientRegisterCenterFields(),
                      ClientAuthFooter(
                          isLogin: false,
                          onLoginPressed: () {
                            if (validateCubit.myForm.currentState!.validate()) {
                              authCubit.userRegister(UserRegisterRequest(
                                name: validateCubit.nameController.text,
                                email: validateCubit.emailController.text,
                                password: validateCubit.passwordController.text,
                                confirmPassword:
                                    validateCubit.passwordController.text,
                              ));
                            }
                          }),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
