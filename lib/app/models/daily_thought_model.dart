import 'package:get/get.dart';

import '../../constants/sizeConstant.dart';

class dailyThoughtModel {
  String? mediaLink;
  String? videoThumbnail;
  int? dateTime;
  String? uId;
  RxBool? isLiked = false.obs;
  RxBool? isDaily = false.obs;

  dailyThoughtModel({
    required this.mediaLink,
    required this.videoThumbnail,
    required this.dateTime,
    required this.uId,
    this.isLiked,
    this.isDaily,
  });

  dailyThoughtModel.fromJson(Map<String, dynamic> json) {
    mediaLink = json['mediaLink'];
    videoThumbnail = json['videoThumbnail'];
    uId = json["uId"];
    dateTime = json["dateTime"];
    isLiked!.value =
        (!isNullEmptyOrFalse(json["isLiked"])) ? json["isLiked"] : false;
    isDaily!.value =
        (!isNullEmptyOrFalse(json["isLiked"])) ? json["isLiked"] : false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mediaLink'] = this.mediaLink;
    data['uId'] = this.uId;
    data['videoThumbnail'] = this.videoThumbnail;
    data['dateTime'] = this.dateTime;
    data['isLiked'] = this.isLiked;
    data['isDaily'] = this.isDaily;
    return data;
  }
}
