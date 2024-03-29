import 'dart:convert';
import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/cupertino.dart';

import 'package:get/get.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import '../../../../constants/api_constants.dart';
import '../../../../constants/firebase_controller.dart';
import '../../../../constants/sizeConstant.dart';
import '../../../../main.dart';
import '../../../../utilities/ad_service.dart';
import '../../../../utilities/timer_service.dart';
import '../../../models/daily_thought_model.dart';

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
  InterstitialAd? interstitialAd;
  RxBool isAdLoaded = false.obs;
  // BannerAd? bannerAd;
  // RxBool isBannerLoaded = false.obs;
  RxBool isAddShow = false.obs;
  SharedPreferences? prefs;
  int launchCount = 0;
  DateTime? currentDate;
  RateMyApp rateMyApp = RateMyApp(
      preferencesPrefix: 'rateMyApp_',
      minDays: 7,
      minLaunches: 10,
      remindDays: 7,
      remindLaunches: 10,
      googlePlayIdentifier: 'com.mobileappxperts.buddhaquotes');
  @override
  Future<void> onInit() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await initPreferences();
      if (shouldShowPopup()) {
        rateMyApp.init().then((value) {
          ShowRateUsPopup();
        });
      }
      await FireController().adsVisible().then((value) async {
        isAddShow.value = value;
        await getIt<AdService>().initBannerAds();
        getIt<TimerService>().verifyTimer();
      });

      if (!isNullEmptyOrFalse(box.read(ArgumentConstant.likeList))) {
        likeList = (jsonDecode(box.read(ArgumentConstant.likeList))).toList();
      }
      await FireController().getPostData().then((value) {
        value.reversed.forEach((element) {
          if (likeList.any((e) => e == element.uId.toString())) {
            element.isLiked!.value = true;
          }
          if (!post.contains(element)) {
            element.isDaily!.value = false;
            post.add(element);
          }
        });
        print("Length := ${post.length}");
        update();
      }).catchError((error) {
        print(error);
      });
      await FireController().getDailyData().then((value) {
        value.reversed.forEach((element) {
          if (likeList.contains(element.uId.toString())) {
            element.isLiked!.value = true;
          }
          if (!post.contains(element)) {
            element.isDaily!.value = true;
            post.add(element);
            print(element.isDaily);
          }
        });
        print("DaiLength := ${value.length}");

        update();
      }).catchError((error) {
        print(error);
      });
      box.write(ArgumentConstant.isFirstTime, false);
      if (getIt<TimerService>().is40SecCompleted) {
        await initInterstitialAdAds();
      }
    });
    super.onInit();
  }

  Future<void> initPreferences() async {
    prefs = await SharedPreferences.getInstance();
    launchCount = prefs!.getInt('launchCount') ?? 0;
    currentDate = DateTime.now();
    prefs!.setString('lastLaunchDate', currentDate.toString());
    prefs!.setInt('launchCount', launchCount + 1);
  }

  bool shouldShowPopup() {
    final lastLaunchDate = prefs!.getString('lastLaunchDate');
    final parsedDate = DateTime.tryParse(lastLaunchDate!);
    final currentDate = DateTime.now();

    if (parsedDate != null) {
      final difference = currentDate.difference(parsedDate).inDays;
      return difference >= 7 && launchCount > 7;
    }

    return false;
  }

  ShowRateUsPopup() {
    rateMyApp.showRateDialog(
      Get.context!,
      title: 'Rate this app', // The dialog title.0
      message:
          'If you like this app, please take a little bit of your time to review it !\nIt really helps us and it shouldn\'t take you more than one minute.', // The dialog message.
      rateButton: 'RATE', // The dialog "rate" button text.
      noButton: 'NO THANKS', // The dialog "no" button text.
      laterButton: 'MAYBE LATER', // The dialog "later" button text.
      listener: (button) {
        // The button click listener (useful if you want to cancel the click event).
        switch (button) {
          case RateMyAppDialogButton.rate:
            print('Clicked on "Rate".');
            break;
          case RateMyAppDialogButton.later:
            print('Clicked on "Later".');
            break;
          case RateMyAppDialogButton.no:
            print('Clicked on "No".');
            break;
        }

        return true; // Return false if you want to cancel the click event.
      },
      ignoreNativeDialog: Platform
          .isAndroid, // Set to false if you want to show the Apple's native app rating dialog on iOS or Google's native app rating dialog (depends on the current Platform).
      dialogStyle: const DialogStyle(), // Custom dialog styles.
      onDismissed: () => rateMyApp.callEvent(RateMyAppEventType
          .laterButtonPressed), // Called when the user dismissed the dialog (either by taping outside or by pressing the "back" button).
    );
  }

  initInterstitialAdAds() async {
    InterstitialAd.load(
        adUnitId: "ca-app-pub-8608272927918158/1905095413",
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            interstitialAd = ad;
            isAdLoaded.value = true;
            if (!isNullEmptyOrFalse(isAddShow.value)) {
              if (isAdLoaded.value) {
                interstitialAd!.show().then((value) {
                  getIt<TimerService>().verifyTimer();
                  if (!isNullEmptyOrFalse(mediaLink)) {
                    getVideo(mediaLink: mediaLink!.value);
                  }
                });
              }
            }
          },
          onAdFailedToLoad: (error) {
            getIt<TimerService>().verifyTimer();
            if (!isNullEmptyOrFalse(mediaLink)) {
              getVideo(mediaLink: mediaLink!.value);
            }
            // Get.back();
            interstitialAd!.dispose();
          },
        ));
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
    getIt<AdService>().dispose();
    if (!isNullEmptyOrFalse(isAddShow.value)) {
      if (isAdLoaded.value) {
        interstitialAd!.dispose();
      }
    }
    if (isVideo.isTrue) {
      flickManager!.value.dispose();
    }
    super.onClose();
  }
}
