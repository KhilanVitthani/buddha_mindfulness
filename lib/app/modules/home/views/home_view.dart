import 'package:buddha_mindfulness/app/models/data_model.dart';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
      body: StreamBuilder<QuerySnapshot>(
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
                        if (dataModel.video != "") {
                          controller.videoPlayerController =
                              VideoPlayerController.network(
                            dataModel.video.toString(),
                          )..initialize().then((_) {});

                          controller.chewie = ChewieController(
                            videoPlayerController:
                                controller.videoPlayerController!,
                            autoPlay: false,
                            looping: false,
                            allowFullScreen: false,
                            autoInitialize: false,
                          );
                        }

                        return Container(
                          child: (dataModel.image!.isNotEmpty)
                              ? getImageByLink(
                                  url: dataModel.image.toString(),
                                  height: MySize.getHeight(25),
                                  width: MySize.getWidth(25),
                                  boxFit: BoxFit.fill)
                              : Chewie(controller: controller.chewie!),
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
    );
  }
}
