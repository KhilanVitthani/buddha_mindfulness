import 'dart:convert';

import 'package:get/get.dart';

import '../../../../constants/api_constants.dart';
import '../../../../constants/sizeConstant.dart';
import '../../../../main.dart';

class AllPostScreenController extends GetxController {
  List likeList = [];

  @override
  void onInit() {
    if (!isNullEmptyOrFalse(box.read(ArgumentConstant.likeList))) {
      likeList = (jsonDecode(box.read(ArgumentConstant.likeList))).toList();
    }
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
