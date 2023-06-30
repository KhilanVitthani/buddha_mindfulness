import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/api_constants.dart';
import '../../../../constants/firebase_controller.dart';
import '../../../../constants/sizeConstant.dart';
import '../../../../main.dart';
import '../../../../utilities/ad_service.dart';
import '../../../routes/app_pages.dart';

class SplashScreenController extends GetxController {
  RxBool isFirstTime = true.obs;
  RxBool isAddShow = false.obs;
  InterstitialAd? interstitialAd;
  RxBool isAdLoaded = false.obs;
  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await FireController().adsVisible().then((value) {
        isAddShow.value = value;
      });
      if (!isNullEmptyOrFalse(box.read(ArgumentConstant.isFirstTime))) {
        isFirstTime.value = box.read(ArgumentConstant.isFirstTime);
      }
      if (isNullEmptyOrFalse(isFirstTime)) {
        time();
      } else {
        time();
      }
    });

    super.onInit();
  }

  time() async {
    await Timer(Duration(seconds: 3), () async {
      Get.offAllNamed(Routes.HOME);
    });
  }

  // initInterstitialAdAds() async {
  //   InterstitialAd.load(
  //       adUnitId: "ca-app-pub-3940256099942544/1033173712",
  //       request: AdRequest(),
  //       adLoadCallback: InterstitialAdLoadCallback(
  //         onAdLoaded: (ad) async {
  //           interstitialAd = ad;
  //           isAdLoaded.value = true;
  //           if (!isNullEmptyOrFalse(isAddShow.value)) {
  //             if (isAdLoaded.value) {
  //               interstitialAd!.show().then((value) {
  //                 Get.offAllNamed(Routes.HOME);
  //               });
  //             } else {
  //               Get.offAllNamed(Routes.HOME);
  //             }
  //           } else {
  //             Get.offAllNamed(Routes.HOME);
  //           }
  //         },
  //         onAdFailedToLoad: (error) {
  //           Get.offAllNamed(Routes.HOME);
  //           interstitialAd!.dispose();
  //         },
  //       ));
  // }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    if (isAdLoaded.value) {
      interstitialAd!.dispose();
    }
    super.onClose();
  }
}
