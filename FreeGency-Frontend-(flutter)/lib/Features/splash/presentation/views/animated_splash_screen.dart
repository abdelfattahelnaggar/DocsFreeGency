import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:freegency_gp/Features/onBoarding/presentation/views/onboarding_screen.dart';
import 'package:freegency_gp/Features/splash/presentation/views/lottie_splash_body.dart';
import 'package:freegency_gp/core/utils/constants/routes.dart';
import 'package:freegency_gp/core/utils/local_storage/local_storage.dart';
import 'package:get/get.dart';

class AnimatedSplashScreen extends StatefulWidget {
  static const routeName = '/animated_splash_screen';

  const AnimatedSplashScreen({super.key});

  @override
  State<AnimatedSplashScreen> createState() => _AnimatedSplashScreenState();
}

class _AnimatedSplashScreenState extends State<AnimatedSplashScreen> {
  @override
  void initState() {
    super.initState();
    // Remove native splash as soon as the Flutter app is initialized
    FlutterNativeSplash.remove();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Let the Lottie animation play for its duration
    await Future.delayed(const Duration(seconds: 4));

    try {
      final isOnboardingCompleted = await LocalStorage.isOnboardingCompleted();
      final isLoggedIn = await LocalStorage.isLoggedIn();
      final isGuest = await LocalStorage.isGuest();

      if (!isOnboardingCompleted) {
        Get.off(
          const OnboardingScreen(),
          transition: Transition.fade,
          duration: const Duration(milliseconds: 500),
        );
      } else if (isLoggedIn || isGuest) {
        Get.offAllNamed(AppRoutes.clientHome);
      } else {
        Get.offAllNamed(AppRoutes.auth);
      }
    } catch (e) {
      Get.offAllNamed(AppRoutes.auth);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use primary color for background
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: const LottieSplashBody(),
    );
  }
}
