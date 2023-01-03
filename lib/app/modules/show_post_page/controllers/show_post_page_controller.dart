import 'package:buddha_mindfulness/constants/api_constants.dart';
import 'package:chewie/chewie.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../../models/data_model.dart';

class ShowPostPageController extends GetxController {
  DataModel? postData;
  VideoPlayerController? videoPlayerController;
  Rx<FlickManager>? flickManager;

  @override
  void onInit() {
    if (Get.arguments != null) {
      postData = Get.arguments[ArgumentConstant.post];
      print(postData!.videoThumbnail);
    }
    if (postData!.isVideo!) {
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
    flickManager!.value.dispose();

    super.dispose();
  }

  @override
  void onClose() {
    super.onClose();
    flickManager!.value.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }
}
