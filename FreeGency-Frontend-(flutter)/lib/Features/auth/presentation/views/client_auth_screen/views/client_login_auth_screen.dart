import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/auth/data/models/client_models/user_login_request_model.dart';
import 'package:freegency_gp/Features/auth/presentation/view_model/cubits/auth_cubit/user_auth_cubit/user_auth_cubit.dart';
import 'package:freegency_gp/Features/auth/presentation/view_model/cubits/validation_cubit/validation_cubit.dart';
import 'package:freegency_gp/Features/auth/presentation/views/client_auth_screen/widgets/client_auth_footer.dart';
import 'package:freegency_gp/Features/auth/presentation/views/client_auth_screen/widgets/client_login_center_fields_section.dart';
import 'package:freegency_gp/Features/auth/presentation/widgets/top_welcome_message.dart';

class ClientLoginScreen extends StatelessWidget {
  const ClientLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => ValidationCubit(),
            ),
            BlocProvider(
              create: (context) => UserAuthCubit(),
            ),
          ],
          child: const ClientLoginScreenBody(),
        ),
      ),
    );
  }
}

class ClientLoginScreenBody extends StatelessWidget {
  const ClientLoginScreenBody({
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
                      TopWelcomeMessage(
                        largeText: context.tr('welcome'),
                        descriptionText:
                            'Join as a Client and find the perfect team for your next big idea!\nSign up to connect with top agencies and teams ready to bring your vision to life.',
                      ),
                      const ClientLoginCenterFieldsSection(),
                      ClientAuthFooter(
                          isLogin: true,
                          onLoginPressed: () {
                            if (validateCubit.myForm.currentState!.validate()) {
                              authCubit.userLogin(UserLoginRequestModel(
                                email: validateCubit.emailController.text,
                                password: validateCubit.passwordController.text,
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
