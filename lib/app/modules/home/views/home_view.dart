import 'package:buddha_mindfulness/app/models/daily_thought_model.dart';
import 'package:buddha_mindfulness/app/models/data_model.dart';
import 'package:buddha_mindfulness/app/models/save_model.dart';
import 'package:buddha_mindfulness/app/routes/app_pages.dart';
import 'package:buddha_mindfulness/constants/api_constants.dart';
import 'package:buddha_mindfulness/constants/color_constant.dart';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gallery_saver/gallery_saver.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

import '../../../../constants/firebase_controller.dart';
import '../../../../constants/sizeConstant.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetWidget<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: MySize.getWidth(4)),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: MySize.getHeight(40), bottom: MySize.getHeight(8)),
              child: Text(
                "Today’s Quote",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: MySize.getHeight(26),
                    color: appTheme.primaryTheme),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                builder: (context, data) {
                  if (data.connectionState == ConnectionState.waiting) {
                    print("object");
                    return Center(child: CircularProgressIndicator());
                  } else if (data.hasError) {
                    print("object");
                    return Text(
                      "Error",
                      style: TextStyle(color: Colors.amber),
                    );
                  } else {
                    return Column(
                      children: [
                        Expanded(
                          child: Container(
                            child: GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 1,
                                      crossAxisSpacing: MySize.getHeight(10.0),
                                      mainAxisSpacing: MySize.getHeight(10.0)),
                              itemBuilder: (context, index) {
                                dailyThoughtModel dailyThought =
                                    dailyThoughtModel.fromJson(
                                  data.data!
                                      .docs[data.data!.docs.length - index - 1]
                                      .data() as Map<String, dynamic>,
                                );
                                if (controller.likeList
                                    .contains(dailyThought.uId!)) {
                                  dailyThought.isLiked!.value = true;
                                }
                                print(DateTime.now());
                                print(dailyThought.mediaLink);
                                if (!isNullEmptyOrFalse(
                                    dailyThought.videoThumbnail)) {
                                  controller.flickManager = FlickManager(
                                    videoPlayerController:
                                        VideoPlayerController.network(
                                            dailyThought.mediaLink!),
                                  ).obs;
                                }

                                return GestureDetector(
                                  onTap: () {},
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: MySize.getWidth(15)),
                                    child: Column(
                                      children: [
                                        Expanded(
                                            child: (!isNullEmptyOrFalse(
                                                    dailyThought
                                                        .videoThumbnail))
                                                ? SizedBox(
                                                    child: Container(
                                                      color: Colors.black,
                                                      height:
                                                          MySize.getHeight(466),
                                                      child: FlickVideoPlayer(
                                                          flickVideoWithControls:
                                                              FlickVideoWithControls(
                                                            videoFit: BoxFit
                                                                .fitHeight,
                                                            controls:
                                                                FlickPortraitControls(),
                                                          ),
                                                          flickManager:
                                                              controller
                                                                  .flickManager!
                                                                  .value),
                                                    ),
                                                  )
                                                : getImageByLink(
                                                    url:
                                                        dailyThought.mediaLink!,
                                                    height:
                                                        MySize.getHeight(325),
                                                    width: MySize.getWidth(320),
                                                    boxFit: BoxFit.contain)),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: MySize.getHeight(15.75)),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: MySize.getWidth(14),
                                              ),
                                              Obx(() {
                                                return GestureDetector(
                                                  onTap: () {
                                                    dailyThought.isLiked!
                                                        .toggle();
                                                    if (dailyThought
                                                        .isLiked!.isTrue) {
                                                      controller.addDataToLike(
                                                          data: dailyThought
                                                              .uId!);
                                                    } else {
                                                      controller
                                                          .removeDataToLike(
                                                              data: dailyThought
                                                                  .uId!);
                                                    }
                                                  },
                                                  child: (dailyThought
                                                          .isLiked!.isTrue)
                                                      ? Icon(Icons.favorite)
                                                      : SvgPicture.asset(
                                                          imagePath +
                                                              "like.svg",
                                                          height:
                                                              MySize.getHeight(
                                                                  22.94),
                                                        ),
                                                );
                                              }),
                                              SizedBox(
                                                width: MySize.getWidth(25),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  if (isNullEmptyOrFalse(
                                                      dailyThought
                                                          .videoThumbnail)) {
                                                    String path = dailyThought
                                                        .mediaLink
                                                        .toString();
                                                    print(path);
                                                    GallerySaver.saveImage(path)
                                                        .then((value) {
                                                      print("Success");
                                                    });
                                                  } else {
                                                    String path = dailyThought
                                                        .mediaLink
                                                        .toString();
                                                    print(path);
                                                    GallerySaver.saveVideo(path)
                                                        .then((value) {
                                                      print("Success");
                                                    });
                                                  }
                                                },
                                                child: SvgPicture.asset(
                                                  imagePath + "down.svg",
                                                  height:
                                                      MySize.getHeight(22.94),
                                                ),
                                              ),
                                              SizedBox(
                                                width: MySize.getWidth(25),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Share.share(
                                                      dailyThought.mediaLink!);
                                                },
                                                child: SvgPicture.asset(
                                                  imagePath + "share.svg",
                                                  height:
                                                      MySize.getHeight(22.94),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                              itemCount: 1,
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
                stream: FireController().getDailyThought(),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MySize.getWidth(10)),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Recent",
                        style: TextStyle(
                            fontSize: MySize.getHeight(18),
                            color: appTheme.textGrayColor,
                            fontWeight: FontWeight.w500),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          Get.offAndToNamed(Routes.ALL_POST_SCREEN);
                        },
                        child: Container(
                          child: Row(
                            children: [
                              Text(
                                "view all",
                                style: TextStyle(
                                  fontSize: MySize.getHeight(15),
                                  fontWeight: FontWeight.w400,
                                  color: appTheme.textGrayColor,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_outlined,
                                color: appTheme.textGrayColor,
                                size: MySize.getHeight(15),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                    height: MySize.getHeight(268),
                    child: StreamBuilder<QuerySnapshot>(
                      builder: (context, data) {
                        if (data.connectionState == ConnectionState.waiting) {
                          print("object");
                          return Center(child: CircularProgressIndicator());
                        } else if (data.hasError) {
                          print("object");
                          return Text(
                            "Error",
                            style: TextStyle(color: Colors.amber),
                          );
                        } else {
                          return Column(
                            children: [
                              Expanded(
                                child: Container(
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: MySize.getHeight(2),
                                      mainAxisSpacing: MySize.getHeight(2),
                                    ),
                                    itemBuilder: (context, index) {
                                      dailyThoughtModel dataModel =
                                          dailyThoughtModel.fromJson(
                                        data
                                            .data!
                                            .docs[data.data!.docs.length -
                                                index -
                                                1]
                                            .data() as Map<String, dynamic>,
                                      );
                                      print(DateTime.now()
                                          .microsecondsSinceEpoch);
                                      return GestureDetector(
                                        onTap: () {
                                          Get.offAndToNamed(
                                              Routes.SHOW_POST_PAGE,
                                              arguments: {
                                                ArgumentConstant.post:
                                                    dataModel,
                                              });
                                        },
                                        child: Stack(
                                          children: [
                                            Container(
                                                height: MySize.safeHeight,
                                                width: MySize.safeWidth,
                                                color: Colors.black,
                                                child: getImageByLink(
                                                    url: (!isNullEmptyOrFalse(
                                                            dataModel
                                                                .videoThumbnail))
                                                        ? dataModel
                                                            .videoThumbnail
                                                            .toString()
                                                        : dataModel.mediaLink
                                                            .toString(),
                                                    height:
                                                        MySize.getHeight(25),
                                                    width: MySize.getWidth(25),
                                                    boxFit: BoxFit.cover)),
                                            (!isNullEmptyOrFalse(
                                                    dataModel.videoThumbnail))
                                                ? Positioned(
                                                    top: MySize.getHeight(10),
                                                    right: MySize.getHeight(10),
                                                    child: Container(
                                                      child: SvgPicture.asset(
                                                          imagePath +
                                                              "video.svg",
                                                          color: Colors.white),
                                                      height: 25,
                                                      width: 25,
                                                    ),
                                                  )
                                                : SizedBox(),
                                          ],
                                        ),
                                      );
                                    },
                                    itemCount: data.data!.docs.length,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      },
                      stream: FireController().getPost(),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MySize.getHeight(20),
            )
          ],
        ),
      ),
    );
  }
}
