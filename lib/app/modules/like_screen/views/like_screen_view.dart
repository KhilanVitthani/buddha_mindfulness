import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../../../../constants/api_constants.dart';
import '../../../../constants/firebase_controller.dart';
import '../../../../constants/sizeConstant.dart';
import '../../../models/daily_thought_model.dart';
import '../../../routes/app_pages.dart';
import '../controllers/like_screen_controller.dart';

class LikeScreenView extends GetView<LikeScreenController> {
  const LikeScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LikeScreenView'),
        centerTitle: true,
      ),
      body: Column(
        children: [
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
                                data.data!.docs
                                    .where((element) => controller.likeList
                                        .contains(dailyThoughtModel
                                            .fromJson(element.data()
                                                as Map<String, dynamic>)
                                            .uId!))
                                    .toList()[index]
                                    .data() as Map<String, dynamic>,
                              );
                              print(DateTime.now().microsecondsSinceEpoch);
                              return GestureDetector(
                                onTap: () {
                                  Get.offAndToNamed(Routes.SHOW_POST_PAGE,
                                      arguments: {
                                        ArgumentConstant.post: dataModel,
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
                                                    dataModel.videoThumbnail))
                                                ? dataModel.videoThumbnail
                                                    .toString()
                                                : dataModel.mediaLink
                                                    .toString(),
                                            height: MySize.getHeight(25),
                                            width: MySize.getWidth(25),
                                            boxFit: BoxFit.cover)),
                                    (!isNullEmptyOrFalse(
                                            dataModel.videoThumbnail))
                                        ? Positioned(
                                            top: MySize.getHeight(10),
                                            right: MySize.getHeight(10),
                                            child: Container(
                                              child: SvgPicture.asset(
                                                  imagePath + "video.svg",
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
                            itemCount: data.data!.docs
                                .where((element) => controller.likeList
                                    .contains(dailyThoughtModel
                                        .fromJson(element.data()
                                            as Map<String, dynamic>)
                                        .uId!))
                                .length,
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
        ],
      ),
    );
  }
}
