import 'dart:convert';

import 'package:buddha_mindfulness/app/models/daily_thought_model.dart';
import 'package:buddha_mindfulness/constants/api_constants.dart';
import 'package:buddha_mindfulness/constants/sizeConstant.dart';
import 'package:buddha_mindfulness/main.dart';
import 'package:chewie/chewie.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:yodo1mas/Yodo1MAS.dart';

import '../../../../utilities/ad_service.dart';
import '../../../../utilities/timer_service.dart';

class HomeController extends GetxController {
  RxBool isSave = false.obs;
  RxBool isLike = false.obs;
  RxBool isTaped = false.obs;
  RxBool isVideo = false.obs;
  RxList<dailyThoughtModel> post = RxList<dailyThoughtModel>([]);
  List likeList = [];
  Rx<FlickManager>? flickManager;
  RxString? deviceId = "".obs;
  Rx<ChewieController>? chewieController;
  @override
  void onInit() {
    if (!isNullEmptyOrFalse(box.read(ArgumentConstant.likeList))) {
      likeList = (jsonDecode(box.read(ArgumentConstant.likeList))).toList();
    }
    Yodo1MAS.instance.setInterstitialListener((event, message) {
      switch (event) {
        case Yodo1MAS.AD_EVENT_OPENED:
          print('Interstitial AD_EVENT_OPENED');
          break;
        case Yodo1MAS.AD_EVENT_ERROR:
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

  ads() async {
    await getIt<AdService>()
        .getAd(adType: AdService.interstitialAd)
        .then((value) {
      if (!value) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        Get.back();
      }
    }).catchError((error) {
      print("Error := $error");
    });
  }

  addDataToLike({
    required String data,
  }) {
    likeList.add(data);
    box.write(ArgumentConstant.likeList, jsonEncode(likeList));
    print(box.read(ArgumentConstant.likeList));
  }

  removeDataToLike({required String data}) {
    likeList.remove(data);
    box.write(ArgumentConstant.likeList, jsonEncode(likeList));
    print(box.read(ArgumentConstant.likeList));
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    if (isVideo.isTrue) {
      flickManager!.value.dispose();
    }
    super.onClose();
  }
}
