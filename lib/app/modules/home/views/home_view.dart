import 'package:buddha_mindfulness/app/models/data_model.dart';
import 'package:buddha_mindfulness/app/routes/app_pages.dart';
import 'package:buddha_mindfulness/constants/api_constants.dart';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
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
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: MySize.getWidth(4)),
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
              data.data!.docs.forEach((element) {});

              print("Data:-${data.data!}");
              return Column(
                children: [
                  Expanded(
                    child: Container(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: MySize.getHeight(10.0),
                            mainAxisSpacing: MySize.getHeight(10.0)),
                        itemBuilder: (context, index) {
                          DataModel dataModel = DataModel.fromJson(
                            data.data!.docs[data.data!.docs.length - index - 1]
                                .data() as Map<String, dynamic>,
                          );

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
                                        url: (dataModel.isVideo!)
                                            ? dataModel.videoThumbnail
                                                .toString()
                                            : dataModel.mediaLink.toString(),
                                        height: MySize.getHeight(25),
                                        width: MySize.getWidth(25),
                                        boxFit: BoxFit.contain)),
                                (dataModel.isVideo!)
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
              );
            }
          },
          stream: FireController().getEntry(),
        ),
      ),
    );
  }
}
