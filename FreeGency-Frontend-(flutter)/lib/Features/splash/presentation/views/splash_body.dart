import 'package:flutter/material.dart';
import 'package:freegency_gp/Features/splash/presentation/views/widgets/positioned_svg.dart';
import 'package:freegency_gp/core/shared/widgets/freegency_app_logo.dart';

class SplashBody extends StatefulWidget {
  const SplashBody({super.key});

  @override
  State<SplashBody> createState() => _SplashBodyState();
}

class _SplashBodyState extends State<SplashBody> with TickerProviderStateMixin {
  late AnimationController firstStageController;
  late AnimationController secondStageController;
  late Animation<double> scaleAnimation;
  late Animation<double> fadeAnimation;
  late List<Animation<Offset>> slideAnimations;
  late List<Animation<Offset>> centerAnimations;

  @override
  void initState() {
    super.initState();
    firstStageController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    secondStageController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    scaleAnimationMethod();

    fadeAnimationMethod();

    forwardAndNavigate();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    slideAnimations = positionsAndImages.map((position) {
      final double x = position['x'].toDouble();
      final double y = position['y'].toDouble();

      final Offset beginOffset = Offset((x - screenWidth / 2) / screenWidth,
          (y - screenHeight / 2) / screenHeight);
      return Tween<Offset>(begin: beginOffset, end: Offset.zero).animate(
        CurvedAnimation(parent: firstStageController, curve: Curves.elasticOut),
      );
    }).toList();

    centerAnimations = positionsAndImages.map((position) {
      final double x = position['x'].toDouble();
      final double y = position['y'].toDouble();

      final double centerX = (screenWidth / 2 - x) / screenWidth;
      final double centerY = (screenHeight / 2 - y) / screenHeight;

      return Tween<Offset>(begin: Offset.zero, end: Offset(centerX, centerY))
          .animate(
        CurvedAnimation(
            parent: secondStageController, curve: Curves.elasticOut),
      );
    }).toList();

    firstStageController.forward();
  }

  @override
  void dispose() {
    firstStageController.dispose();
    secondStageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: FadeTransition(
            opacity: fadeAnimation,
            child: ScaleTransition(
              scale: scaleAnimation,
              child: const FreeGencyLogo(),
            ),
          ),
        ),
        ...List.generate(
          positionsAndImages.length,
          (index) => AnimatedBuilder(
            animation:
                Listenable.merge([firstStageController, secondStageController]),
            builder: (context, child) {
              return Positioned(
                left: positionsAndImages[index]['x'].toDouble(),
                top: positionsAndImages[index]['y'].toDouble(),
                child: FadeTransition(
                  opacity: fadeAnimation,
                  child: SlideTransition(
                    position: slideAnimations[index],
                    child: SlideTransition(
                      position: centerAnimations[index],
                      child: ScaleTransition(
                        scale: scaleAnimation,
                        child: PositionedSVG(
                          x: 0,
                          y: 0,
                          path:
                              positionsAndImages[index]['path'] ?? Container(),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void fadeAnimationMethod() {
    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: firstStageController, curve: Curves.elasticOut),
    );
  }

  void scaleAnimationMethod() {
    scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: firstStageController, curve: Curves.elasticOut),
    );
  }

  void forwardAndNavigate() {
    Future.delayed(const Duration(seconds: 6), () {
      if (mounted) {
        // Future.delayed(const Duration(milliseconds: 3500), () {
        //   Get.offAll(const OnboardingScreen(),
        //       transition: Transition.circularReveal,
        //       duration: const Duration(seconds: 2));
        // });
        firstStageController.reverse().then((_) {
          secondStageController.forward();
        });
      }
    });
  }
}

List<Map<String, dynamic>> positionsAndImages = [
  {'path': 'assets/icons/flash_splash.svg', 'x': 70, 'y': 129},
  {'path': 'assets/icons/dashs_splash.svg', 'x': 134, 'y': 180},
  {'path': 'assets/icons/dots_splash.svg', 'x': 350, 'y': 80},
  {'path': 'assets/icons/mic_splash.svg', 'x': -10, 'y': 600},
  {'path': 'assets/icons/pencil_splash.svg', 'x': 334, 'y': 330},
  {'path': 'assets/icons/smile_splash.svg', 'x': 250, 'y': 700},
  {'path': 'assets/icons/x_splash.svg', 'x': 293, 'y': 590},
];
