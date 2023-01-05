import 'package:flick_video_player/flick_video_player.dart';
import 'package:get/get.dart';
import '../../../models/data_model.dart';

class HomeController extends GetxController {
  RxBool isSave = false.obs;
  RxBool isLike = false.obs;
  RxList<DataModel> postList = RxList<DataModel>([]);
  Rx<FlickManager>? flickManager;
  RxString? deviceId = "".obs;
  @override
  void onInit() {
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
