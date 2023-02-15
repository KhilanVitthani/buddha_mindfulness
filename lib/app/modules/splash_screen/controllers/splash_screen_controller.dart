import 'dart:async';

import 'package:buddha_mindfulness/app/routes/app_pages.dart';
import 'package:buddha_mindfulness/constants/api_constants.dart';
import 'package:buddha_mindfulness/main.dart';
import 'package:buddha_mindfulness/utilities/timer_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:yodo1mas/Yodo1MAS.dart';

import '../../../../utilities/ad_service.dart';

class SplashScreenController extends GetxController {
  RxBool isFirstTime = false.obs;
  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (box.read(ArgumentConstant.isFirstTime) != null) {
        isFirstTime.value = box.read(ArgumentConstant.isFirstTime);
      }
      if (isFirstTime.value) {
        Get.offAllNamed(Routes.HOME);
      } else {
        await ads();
      }
      Yodo1MAS.instance.setInterstitialListener((event, message) {
        switch (event) {
          case Yodo1MAS.AD_EVENT_OPENED:
            print('Interstitial AD_EVENT_OPENED');
            break;
          case Yodo1MAS.AD_EVENT_ERROR:
            getIt<TimerService>().verifyTimer();
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
            Get.offAndToNamed(Routes.HOME);
            print('Interstitial AD_EVENT_ERROR' + message);
            break;
          case Yodo1MAS.AD_EVENT_CLOSED:
            getIt<TimerService>().verifyTimer();
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
            Get.offAndToNamed(Routes.HOME);
            break;
        }
      });
    });

    super.onInit();
  }

  time() async {
    (AdService.isVisible.isTrue)
        ? await Timer(Duration(seconds: 8), () async {
            ads();
          })
        : await Timer(Duration(seconds: 5), () async {
            Get.offAllNamed(Routes.HOME);
          });
  }

  ads() async {
    await getIt<AdService>()
        .getAd(adType: AdService.interstitialAd)
        .then((value) {
      if (!value) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        Get.offAndToNamed(Routes.HOME);
      } else {
        Future.delayed(Duration(seconds: 5)).then((value) {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
          Get.offAndToNamed(Routes.HOME);
        });
      }
    }).catchError((error) {
      print("Error := $error");
    });
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
