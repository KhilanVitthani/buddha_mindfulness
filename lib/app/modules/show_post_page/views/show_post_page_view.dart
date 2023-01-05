import 'package:buddha_mindfulness/constants/color_constant.dart';
import 'package:chewie/chewie.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

import '../../../../constants/sizeConstant.dart';
import '../../../routes/app_pages.dart';
import '../controllers/show_post_page_controller.dart';

class ShowPostPageView extends GetWidget<ShowPostPageController> {
  const ShowPostPageView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offAllNamed(Routes.HOME);
        return await true;
      },
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                'ShowPostPageView',
                style: TextStyle(color: appTheme.primaryTheme),
              ),
              centerTitle: true,
              leading: GestureDetector(
                onTap: () async {
                  Get.offAllNamed(Routes.HOME);
                  controller.dispose();
                },
                child: Container(
                  padding: EdgeInsets.only(left: MySize.getWidth(10)),
                  child: Icon(Icons.arrow_back, color: appTheme.primaryTheme),
                ),
              ),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  (!isNullEmptyOrFalse(controller.postData!.videoThumbnail))
                      ? Container(
                          child: (controller.flickManager == null)
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : Container(
                                  height: MySize.getHeight(500),
                                  child: FlickVideoPlayer(
                                      flickVideoWithControls:
                                          FlickVideoWithControls(
                                        videoFit: BoxFit.fitHeight,
                                        controls: FlickPortraitControls(
                                            // progressBarSettings:
                                            //     FlickProgressBarSettings(
                                            //   playedColor: Colors.green,
                                            //   backgroundColor: Colors.black,
                                            // ),
                                            ),
                                      ),
                                      flickManager:
                                          controller.flickManager!.value),
                                ),
                        )
                      : Container(
                          alignment: Alignment.center,
                          width: MySize.safeWidth,
                          height: MySize.getHeight(500),
                          child: PinchZoom(
                            child: getImageByLink(
                                url: controller.postData!.mediaLink.toString(),
                                height: MySize.getHeight(25),
                                width: MySize.getWidth(25),
                                boxFit: BoxFit.fill),
                            resetDuration: const Duration(milliseconds: 100),
                            maxScale: MySize.getHeight(5),
                            onZoomStart: () {
                              print('Start zooming');
                            },
                            onZoomEnd: () {
                              print('Stop zooming');
                            },
                          ),
                        )
                ],
              ),
            )),
      ),
    );
  }
}
