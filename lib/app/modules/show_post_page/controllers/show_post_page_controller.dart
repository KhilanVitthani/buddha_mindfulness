import 'dart:convert';

import 'package:buddha_mindfulness/app/models/daily_thought_model.dart';
import 'package:buddha_mindfulness/constants/api_constants.dart';
import 'package:chewie/chewie.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../../../constants/sizeConstant.dart';
import '../../../../main.dart';
import '../../../../utilities/ad_service.dart';
import '../../../models/data_model.dart';

class ShowPostPageController extends GetxController {
  dailyThoughtModel? postData;
  VideoPlayerController? videoPlayerController;
  Rx<FlickManager>? flickManager;
  RxBool isFromHome = false.obs;
  RxBool isFromLike = false.obs;
  List likeList = [];

  @override
  void onInit() {
    if (Get.arguments != null) {
      postData = Get.arguments[ArgumentConstant.post];
      isFromHome.value = Get.arguments[ArgumentConstant.isFromHome];
      isFromLike.value = Get.arguments[ArgumentConstant.isFromLike];
      print(postData!.videoThumbnail);
    }
    if (!isNullEmptyOrFalse(postData!.videoThumbnail)) {
      flickManager = FlickManager(
        videoPlayerController:
            VideoPlayerController.network(postData!.mediaLink!),
      ).obs;
    }
    if (!isNullEmptyOrFalse(box.read(ArgumentConstant.likeList))) {
      likeList = (jsonDecode(box.read(ArgumentConstant.likeList))).toList();
    }
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void dispose() {
    super.dispose();
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
  void onClose() {
    super.onClose();
    if (!isNullEmptyOrFalse(postData!.videoThumbnail)) {
      flickManager!.value.dispose();
    }
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }
}
