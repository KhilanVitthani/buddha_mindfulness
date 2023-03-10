import 'dart:convert';

import 'package:buddha_mindfulness/app/models/daily_thought_model.dart';
import 'package:buddha_mindfulness/constants/api_constants.dart';
import 'package:buddha_mindfulness/constants/sizeConstant.dart';
import 'package:buddha_mindfulness/main.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:yodo1mas/Yodo1MAS.dart';

import '../../../../constants/firebase_controller.dart';
import '../../../../utilities/ad_service.dart';
import '../../../../utilities/timer_service.dart';

class HomeController extends GetxController {
  RxBool isSave = false.obs;
  RxBool isLike = false.obs;
  RxBool isTaped = false.obs;
  RxBool isVideo = false.obs;
  RxBool isFromSplash = false.obs;
  RxList<dailyThoughtModel> post = RxList<dailyThoughtModel>([]);
  RxList<dailyThoughtModel> localPost = RxList<dailyThoughtModel>([]);
  List likeList = [];
  Rx<FlickManager>? flickManager;
  RxString? mediaLink = "".obs;
  @override
  void onInit() {
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    //   if (!isNullEmptyOrFalse(Get.arguments)) {
    //     if (!isNullEmptyOrFalse(Get.arguments[ArgumentConstant.isFromSplash])) {
    //       // await ads();
    //     }
    //   }
    // });
    FireController().getPostData().then((value) {
      value.reversed.forEach((element) {
        if (!post.contains(element)) {
          element.isDaily!.value = false;
          post.add(element);
        }
      });
      update();
    }).catchError((error) {
      print(error);
    });
    FireController().getDailyData().then((value) {
      value.reversed.forEach((element) {
        if (!post.contains(element)) {
          element.isDaily!.value = true;
          post.add(element);
        }
      });
      update();
    }).catchError((error) {
      print(error);
    });

    box.write(ArgumentConstant.isFirstTime, false);
    print(box.read(ArgumentConstant.isFirstTime));
    if (!isNullEmptyOrFalse(box.read(ArgumentConstant.likeList))) {
      likeList = (jsonDecode(box.read(ArgumentConstant.likeList))).toList();
    }
    if (getIt<TimerService>().is40SecCompleted) {
      ads();
    }
    Yodo1MAS.instance.setInterstitialListener((event, message) {
      switch (event) {
        case Yodo1MAS.AD_EVENT_OPENED:
          print('Interstitial AD_EVENT_OPENED');
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
          break;
        case Yodo1MAS.AD_EVENT_ERROR:
          getIt<TimerService>().verifyTimer();
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
          if (!isNullEmptyOrFalse(mediaLink)) {
            getVideo(mediaLink: mediaLink!.value);
          }
          Get.back();
          print('Interstitial AD_EVENT_ERROR' + message);
          break;
        case Yodo1MAS.AD_EVENT_CLOSED:
          getIt<TimerService>().verifyTimer();
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
          if (!isNullEmptyOrFalse(mediaLink)) {
            getVideo(mediaLink: mediaLink!.value);
          }
          Get.back();
          break;
      }
    });
    super.onInit();
  }

  //
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

  addDataToLike({
    required String data,
  }) {
    if (!likeList.contains(data)) {
      likeList.add(data);
    }
    box.write(ArgumentConstant.likeList, jsonEncode(likeList));
    print(box.read(ArgumentConstant.likeList));
  }

  removeDataToLike({required String data}) {
    if (likeList.contains(data)) {
      likeList.remove(data);
    }
    box.write(ArgumentConstant.likeList, jsonEncode(likeList));

    print(box.read(ArgumentConstant.likeList));
  }

  hide() {
    if (isTaped.isTrue) {
      Future.delayed(Duration(seconds: 5)).then((value) {
        isTaped.value = false;
      });
    }
  }

  onVideoEnd() {
    isTaped.value = true;
  }

  getVideo({required String mediaLink}) {
    if (!isNullEmptyOrFalse(mediaLink)) {
      flickManager = FlickManager(
        videoPlayerController: VideoPlayerController.network(mediaLink),
        autoPlay: true,
        onVideoEnd: onVideoEnd(),
      ).obs;
    }
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
