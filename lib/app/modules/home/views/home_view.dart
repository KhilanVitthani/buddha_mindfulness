import 'package:buddha_mindfulness/app/models/daily_thought_model.dart';
import 'package:buddha_mindfulness/app/models/data_model.dart';
import 'package:buddha_mindfulness/app/models/save_model.dart';
import 'package:buddha_mindfulness/app/routes/app_pages.dart';
import 'package:buddha_mindfulness/constants/api_constants.dart';
import 'package:buddha_mindfulness/constants/color_constant.dart';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
                style: GoogleFonts.lato(
                    fontWeight: FontWeight.w700,
                    fontSize: MySize.getHeight(26),
                    color: appTheme.primaryTheme),
              ),
            ),
            Container(
              height: MySize.getHeight(400),
              child: StreamBuilder<DocumentSnapshot<Object?>>(
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
                                  data.data!.data() as Map<String, dynamic>,
                                );
                                print(DateTime.now());
                                print(dailyThought.mediaLink);
                                return GestureDetector(
                                  onTap: () {},
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: MySize.getWidth(15)),
                                    child: Column(
                                      children: [
                                        Container(
                                            child: (dailyThought.isVideo!)
                                                ? Container()
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
                                              GestureDetector(
                                                onTap: () {
                                                  controller.isLike.value =
                                                      !controller.isLike.value;
                                                  FireController().LikeQuote(
                                                      status: controller
                                                          .isLike.value);
                                                },
                                                child: (dailyThought.isLike ==
                                                        true)
                                                    ? Icon(Icons.ac_unit)
                                                    : SvgPicture.asset(
                                                        imagePath + "like.svg",
                                                        height:
                                                            MySize.getHeight(
                                                                22.94),
                                                      ),
                                              ),
                                              SizedBox(
                                                width: MySize.getWidth(25),
                                              ),
                                              SvgPicture.asset(
                                                imagePath + "down.svg",
                                                height: MySize.getHeight(22.94),
                                              ),
                                              SizedBox(
                                                width: MySize.getWidth(25),
                                              ),
                                              SvgPicture.asset(
                                                imagePath + "share.svg",
                                                height: MySize.getHeight(22.94),
                                              ),
                                              Spacer(),
                                              GestureDetector(
                                                onTap: () {
                                                  controller.isSave.value =
                                                      !controller.isSave.value;
                                                  FireController().saveQuote(
                                                      status: controller
                                                          .isSave.value);
                                                  if (dailyThought.isSave ==
                                                      true) {
                                                    FireController().addSaveDataToFireStore(
                                                        saveThoughtModel: SaveThoughtModel(
                                                            mediaLink:
                                                                dailyThought
                                                                    .mediaLink
                                                                    .toString(),
                                                            videoThumbnail:
                                                                dailyThought
                                                                    .videoThumbnail
                                                                    .toString(),
                                                            uId: dailyThought
                                                                .uId
                                                                .toString()));
                                                  }
                                                },
                                                child: (dailyThought.isSave ==
                                                        true)
                                                    ? Icon(Icons.save)
                                                    : SvgPicture.asset(
                                                        imagePath + "save.svg",
                                                        height:
                                                            MySize.getHeight(
                                                                22.94),
                                                      ),
                                              ),
                                              SizedBox(
                                                width: MySize.getWidth(20),
                                              )
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
            SizedBox(
              height: MySize.getHeight(8),
            ),
            // Expanded(
            //   flex: 2,
            //   child: StreamBuilder<QuerySnapshot>(
            //     builder: (context, data) {
            //       if (data.connectionState == ConnectionState.waiting) {
            //         print("object");
            //         return Center(child: CircularProgressIndicator());
            //       } else if (data.hasError) {
            //         print("object");
            //         return Text(
            //           "Error",
            //           style: TextStyle(color: Colors.amber),
            //         );
            //       } else {
            //         data.data!.docs.forEach((element) {});
            //
            //         print("Data:-${data.data!}");
            //         return Column(
            //           children: [
            //             Expanded(
            //               child: Container(
            //                 child: GridView.builder(
            //                   gridDelegate:
            //                       SliverGridDelegateWithFixedCrossAxisCount(
            //                           crossAxisCount: 2,
            //                           crossAxisSpacing: MySize.getHeight(10.0),
            //                           mainAxisSpacing: MySize.getHeight(10.0)),
            //                   itemBuilder: (context, index) {
            //                     DataModel dataModel = DataModel.fromJson(
            //                       data.data!
            //                           .docs[data.data!.docs.length - index - 1]
            //                           .data() as Map<String, dynamic>,
            //                     );
            //                     print(DateTime.now().microsecondsSinceEpoch);
            //                     return GestureDetector(
            //                       onTap: () {
            //                         Get.offAndToNamed(Routes.SHOW_POST_PAGE,
            //                             arguments: {
            //                               ArgumentConstant.post: dataModel,
            //                             });
            //                       },
            //                       child: Stack(
            //                         children: [
            //                           Container(
            //                               height: MySize.safeHeight,
            //                               width: MySize.safeWidth,
            //                               color: Colors.black,
            //                               child: getImageByLink(
            //                                   url: (dataModel.isVideo!)
            //                                       ? dataModel.videoThumbnail
            //                                           .toString()
            //                                       : dataModel.mediaLink
            //                                           .toString(),
            //                                   height: MySize.getHeight(25),
            //                                   width: MySize.getWidth(25),
            //                                   boxFit: BoxFit.contain)),
            //                           (dataModel.isVideo!)
            //                               ? Positioned(
            //                                   top: MySize.getHeight(10),
            //                                   right: MySize.getHeight(10),
            //                                   child: Container(
            //                                     child: SvgPicture.asset(
            //                                         imagePath + "video.svg",
            //                                         color: Colors.white),
            //                                     height: 25,
            //                                     width: 25,
            //                                   ),
            //                                 )
            //                               : SizedBox(),
            //                         ],
            //                       ),
            //                     );
            //                   },
            //                   itemCount: data.data!.docs.length,
            //                 ),
            //               ),
            //             ),
            //           ],
            //         );
            //       }
            //     },
            //     stream: FireController().getPost(),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
