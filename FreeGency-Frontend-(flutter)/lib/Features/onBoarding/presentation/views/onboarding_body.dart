import 'package:flutter/material.dart';
import 'package:freegency_gp/Features/onBoarding/presentation/views/widgets/custom_onboarding_button.dart';
import 'package:freegency_gp/Features/onBoarding/presentation/views/widgets/description_text.dart';
import 'package:freegency_gp/Features/onBoarding/presentation/views/widgets/image_page_view.dart';
import 'package:freegency_gp/Features/onBoarding/presentation/views/widgets/swapping_animated_dots.dart';

class OnboardingBody extends StatefulWidget {
  const OnboardingBody({super.key});

  @override
  State<OnboardingBody> createState() => _OnboardingBodyState();
}

class _OnboardingBodyState extends State<OnboardingBody>
    with SingleTickerProviderStateMixin {
  late AnimationController firstStageController;
  late Animation<Offset> slideAnimations;
  late Animation<double> fadeAnimation;

  @override
  void initState() {
    firstStageController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    slideAnimationsMethod();
    fadeAnimationMethod();

    firstStageController.forward();
    super.initState();
  }

  void slideAnimationsMethod() {
    slideAnimations =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: firstStageController, curve: Curves.easeIn),
    );
  }

  void fadeAnimationMethod() {
    fadeAnimation = Tween<double>(begin: -1, end: 1.0).animate(
      CurvedAnimation(parent: firstStageController, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    firstStageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: FadeTransition(
        opacity: fadeAnimation,
        child: SlideTransition(
          position: slideAnimations,
          child: const Column(
            children: [
              ImagePageView(),
              SwappingDots(),
              DescriptionText(),
              CustomOnBoardingButton(),
            ],
          ),
        ),
      ),
    );
  }
}
