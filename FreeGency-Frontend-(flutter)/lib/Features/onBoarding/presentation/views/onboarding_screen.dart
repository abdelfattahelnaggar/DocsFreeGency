import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/onBoarding/presentation/view_model/cubit/change_scene_cubit/change_scene_cubit.dart';
import 'package:freegency_gp/Features/onBoarding/presentation/views/onboarding_body.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => ChangeSceneCubit(),
        child: const OnboardingBody(),
      ),
    );
  }
}
