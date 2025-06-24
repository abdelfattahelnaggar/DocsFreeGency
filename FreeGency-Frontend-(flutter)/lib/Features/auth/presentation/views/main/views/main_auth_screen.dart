import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/auth/presentation/view_model/cubits/selected_rule_cubit/selected_rule_cubit.dart';
import 'package:freegency_gp/Features/auth/presentation/view_model/cubits/validation_cubit/validation_cubit.dart';
import 'package:freegency_gp/Features/auth/presentation/views/main/widgets/main_auth_page_body.dart';

class MainAuthScreen extends StatelessWidget {
  const MainAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => ValidationCubit(),
            ),
            
            BlocProvider(
              create: (context) => SelectedRuleCubit(),
            ),
          ],
        child: const MainAuthPageBody(),
      ),
    );
  }
}
