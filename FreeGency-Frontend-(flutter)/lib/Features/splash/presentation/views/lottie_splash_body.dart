import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieSplashBody extends StatelessWidget {
  const LottieSplashBody({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isLightMode = brightness == Brightness.light;

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Lottie.asset(
        // Use different Lottie files based on theme
        isLightMode
            ? 'assets/lottie/light_splash.json'
            : 'assets/lottie/dark_splash.json',
        fit: BoxFit.cover,
        repeat: true,
        errorBuilder: (context, error, stackTrace) {
          debugPrint('Error loading Lottie animation: $error');
          // Show an error icon if animation fails to load
          return const Center(
            child: Icon(
              Icons.error_outline,
              color: Colors.white,
              size: 80,
            ),
          );
        },
      ),
    );
  }
}
