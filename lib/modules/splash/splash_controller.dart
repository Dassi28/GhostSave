import 'dart:async';
import 'package:get/get.dart';
import '../../main.dart'; // Pour importer MainLayout

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    // Attendre 2 secondes avant de naviguer
    Timer(const Duration(seconds: 2), () {
      Get.off(() => const MainLayout(), transition: Transition.fadeIn, duration: const Duration(milliseconds: 500));
    });
  }
}
