import 'package:buddha_mindfulness/constants/color_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../../../../constants/api_constants.dart';
import '../../../../constants/firebase_controller.dart';
import '../../../../constants/sizeConstant.dart';
import '../../../../utilities/ad_service.dart';
import '../controllers/splash_screen_controller.dart';

class SplashScreenView extends GetWidget<SplashScreenController> {
  const SplashScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MySize.safeHeight,
          width: MySize.safeWidth,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagePath + "splash.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath + "icon.png",
                height: MySize.getHeight(72),
                width: MySize.getWidth(68),
              ),
              Spacing.height(MySize.getHeight(3)),
              Text(
                "Quote",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: MySize.getHeight(50),
                  color: Color(0xffF8D4CE),
                ),
              ),
              SizedBox(
                height: MySize.getHeight(4),
              ),
              Text(
                "with the new day",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: MySize.getHeight(20),
                  color: Color(0xffF8D4CE),
                ),
              ),
              // StreamBuilder<QuerySnapshot>(
              //   builder: (context, data) {
              //     if (data.connectionState == ConnectionState.waiting) {
              //       return SizedBox();
              //     } else if (data.hasError) {
              //       print("object");
              //       return SizedBox();
              //     } else {
              //       AdService.isVisible.value = data.data!.docs[0]["isVisible"];
              //       controller.isVisible.value = AdService.isVisible.value;
              //       return SizedBox();
              //     }
              //   },
              //   stream: FireController().adsVisible(),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
