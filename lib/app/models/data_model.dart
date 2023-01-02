class DataModel {
  String? image;
  String? video;
  DataModel({required this.image, required this.video});
  DataModel.fromJson(Map<String, dynamic> json) {
    image = json["image"];
    video = json["video"];
  }
}
