import 'dart:convert';

import 'package:buddha_mindfulness/constants/sizeConstant.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:yodo1mas/Yodo1MAS.dart';

import '../../../../constants/api_constants.dart';
import '../../../../main.dart';
import '../../../../utilities/ad_service.dart';
import '../../../../utilities/timer_service.dart';
import '../../../models/daily_thought_model.dart';
import '../../../routes/app_pages.dart';

class LikeScreenController extends GetxController {
  RxList likeList = RxList([]);
  RxList<dailyThoughtModel> likePost = RxList<dailyThoughtModel>([]);
  RxList<dailyThoughtModel> post = RxList<dailyThoughtModel>([]);
  @override
  void onInit() {
    if (!isNullEmptyOrFalse(box.read(ArgumentConstant.likeList))) {
      likeList.value =
          (jsonDecode(box.read(ArgumentConstant.likeList))).toList();
    }
    if (getIt<TimerService>().is40SecCompleted) {
      ads();
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
          Get.back();

          break;
      }
    });

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  Future<void> ads() async {
    await getIt<AdService>()
        .getAd(
      adType: AdService.interstitialAd,
    )
        .then((value) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      if (!value) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        Get.back();
      }
    }).catchError((error) {
      print("Error := $error");
    });
  }

  @override
  void onClose() {
    super.onClose();
  }
}
