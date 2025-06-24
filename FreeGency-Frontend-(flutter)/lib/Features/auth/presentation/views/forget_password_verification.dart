import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/auth/presentation/view_model/cubits/auth_cubit/user_auth_cubit/user_auth_cubit.dart';
import 'package:freegency_gp/Features/auth/presentation/view_model/cubits/validation_cubit/validation_cubit.dart';
import 'package:freegency_gp/Features/auth/presentation/widgets/forget_password_body.dart';

class ForgetPasswordVerificationPage extends StatelessWidget {
  const ForgetPasswordVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ValidationCubit(),
          ),
          BlocProvider(
            create: (context) => UserAuthCubit(),
          ),
        ],
        child: const Scaffold(
          body: ForgetPasswordScreenBody(),
        ),
      ),
    );
  }
}
