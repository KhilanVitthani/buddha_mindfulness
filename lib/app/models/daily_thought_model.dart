class dailyThoughtModel {
  String? mediaLink;
  String? uId;
  bool? isVideo;
  String? videoThumbnail;
  bool? isLike;
  bool? isSave;
  String? dateTime;

  dailyThoughtModel(
      {required this.mediaLink,
      required this.isVideo,
      required this.videoThumbnail,
      required this.isLike,
      required this.uId,
      required this.isSave});

  dailyThoughtModel.fromJson(Map<String, dynamic> json) {
    mediaLink = json['mediaLink'];
    isVideo = json['isVideo'];
    videoThumbnail = json['videoThumbnail'];
    isLike = json['isLike'];
    isSave = json["isSave"];
    uId = json["uId"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mediaLink'] = this.mediaLink;
    data['isVideo'] = this.isVideo;
    data['uId'] = this.uId;
    data['videoThumbnail'] = this.videoThumbnail;
    data['isLike'] = this.isLike;
    data['isSave'] = this.isSave;
    return data;
  }
}
