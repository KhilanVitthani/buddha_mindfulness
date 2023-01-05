import 'package:get/get.dart';

import '../app/routes/app_pages.dart';

const imagePath = "assets/images/";
const feedBackEmail = "mobileappxperts3@gmail.com";

class ArgumentConstant {
  static const post = "post";
  static const likeList = "likeList";
}

getLogOut() {
  Get.offAllNamed(Routes.HOME);
}
