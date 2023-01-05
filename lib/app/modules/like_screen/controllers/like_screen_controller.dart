import 'dart:convert';

import 'package:get/get.dart';

import '../../../../constants/api_constants.dart';
import '../../../../main.dart';

class LikeScreenController extends GetxController {
  RxList likeList = RxList([]);

  @override
  void onInit() {
    likeList.value = (jsonDecode(box.read(ArgumentConstant.likeList))).toList();
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
