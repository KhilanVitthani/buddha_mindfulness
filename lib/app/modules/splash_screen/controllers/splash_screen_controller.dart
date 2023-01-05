import 'dart:async';

import 'package:buddha_mindfulness/app/routes/app_pages.dart';
import 'package:get/get.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    Timer(Duration(seconds: 3), () {
      Get.offAndToNamed(Routes.HOME);
    });
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
