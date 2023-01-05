import 'package:buddha_mindfulness/constants/color_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../../../../constants/api_constants.dart';
import '../../../../constants/firebase_controller.dart';
import '../../../../constants/sizeConstant.dart';
import '../../../models/daily_thought_model.dart';
import '../../../routes/app_pages.dart';
import '../controllers/all_post_screen_controller.dart';

class AllPostScreenView extends GetView<AllPostScreenController> {
  const AllPostScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Quotes',
            style: TextStyle(
                color: appTheme.primaryTheme,
                fontWeight: FontWeight.w700,
                fontSize: MySize.getHeight(26))),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MySize.getWidth(8),
        ),
        child: Column(
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
                    return Padding(
                      padding: EdgeInsets.only(top: MySize.getHeight(20)),
                      child: Column(
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
                                        .docs[
                                            data.data!.docs.length - index - 1]
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
                                                        dataModel
                                                            .videoThumbnail))
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
                                itemCount: data.data!.docs.length,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
                stream: FireController().getPost(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
