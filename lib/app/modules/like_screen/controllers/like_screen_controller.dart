import 'dart:convert';

import 'package:buddha_mindfulness/constants/sizeConstant.dart';
import 'package:get/get.dart';

import '../../../../constants/api_constants.dart';
import '../../../../main.dart';
import '../../../models/daily_thought_model.dart';

class LikeScreenController extends GetxController {
  RxList likeList = RxList([]);
  RxList<dailyThoughtModel> likePost = RxList<dailyThoughtModel>([]);
  RxList<dailyThoughtModel> post = RxList<dailyThoughtModel>([]);
  @override
  void onInit() {
    if (!isNullEmptyOrFalse(box.read(ArgumentConstant.likeList)))
      likeList.value =
          (jsonDecode(box.read(ArgumentConstant.likeList))).toList();

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
