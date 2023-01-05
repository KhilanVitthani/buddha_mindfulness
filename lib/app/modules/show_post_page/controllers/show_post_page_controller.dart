import 'package:buddha_mindfulness/app/models/daily_thought_model.dart';
import 'package:buddha_mindfulness/constants/api_constants.dart';
import 'package:chewie/chewie.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../../../constants/sizeConstant.dart';
import '../../../models/data_model.dart';

class ShowPostPageController extends GetxController {
  dailyThoughtModel? postData;
  VideoPlayerController? videoPlayerController;
  Rx<FlickManager>? flickManager;

  @override
  void onInit() {
    if (Get.arguments != null) {
      postData = Get.arguments[ArgumentConstant.post];
      print(postData!.videoThumbnail);
    }
    if (!isNullEmptyOrFalse(postData!.videoThumbnail)) {
      final videoPlayerController =
          VideoPlayerController.network(postData!.mediaLink!);

      flickManager = FlickManager(
        videoPlayerController:
            VideoPlayerController.network(postData!.mediaLink!),
      ).obs;
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

  @override
  void onClose() {
    super.onClose();
    if (!isNullEmptyOrFalse(postData!.videoThumbnail)) {
      flickManager!.value.dispose();
    }
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }
}
