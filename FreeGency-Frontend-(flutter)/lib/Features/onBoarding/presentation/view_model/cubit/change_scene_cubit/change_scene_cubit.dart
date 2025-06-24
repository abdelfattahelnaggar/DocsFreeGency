import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/auth/presentation/views/main/views/main_auth_screen.dart';
import 'package:freegency_gp/core/utils/local_storage/local_storage.dart';
import 'package:get/get.dart' as getx;
import 'package:get/get.dart';

part 'change_scene_state.dart';

class ChangeSceneCubit extends Cubit<ChangeSceneState> {
  ChangeSceneCubit() : super(ChangeSceneInitial()) {
    pageController = PageController(initialPage: currentIndex);
  }

  int currentIndex = 0;
  late PageController pageController;

  void updateCurrentIndex(int index) {
    currentIndex = index;
    emit(SceneChangedState());
  }

  Future<void> goToNextPage() async {
    if (currentIndex < 3) {
      currentIndex++;
      emit(SceneChangedState());
      pageController.animateToPage(
        currentIndex,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    } else {
      await LocalStorage.setOnboardingCompleted();
      Get.offAll(
        const MainAuthScreen(),
        transition: getx.Transition.rightToLeft,
        duration: const Duration(seconds: 1),
      );
    }
  }

  String buttonText() {
    if (currentIndex != 3) {
      return 'Next';
    } else {
      return 'Get Started';
    }
  }

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }
}
