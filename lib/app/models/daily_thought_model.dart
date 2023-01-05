class dailyThoughtModel {
  String? mediaLink;
  String? uId;
  String? videoThumbnail;
  String? dateTime;

  dailyThoughtModel({
    required this.mediaLink,
    required this.videoThumbnail,
    required this.uId,
  });

  dailyThoughtModel.fromJson(Map<String, dynamic> json) {
    mediaLink = json['mediaLink'];
    videoThumbnail = json['videoThumbnail'];
    uId = json["uId"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mediaLink'] = this.mediaLink;
    data['uId'] = this.uId;
    data['videoThumbnail'] = this.videoThumbnail;
    return data;
  }
}
