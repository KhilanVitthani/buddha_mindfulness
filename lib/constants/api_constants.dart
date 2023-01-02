import 'package:get/get.dart';

import '../app/routes/app_pages.dart';

const imagePath = "assets/images/";
const baseUrl = "https://member.imglarger.com/api/";
const imageCartton = "https://access2.imglarger.com:8997/";
const feedBackEmail = "mobileappxperts3@gmail.com";

class ApiConstant {
  static const login = "User/Login";
  static const upload = "upload";
}

class ArgumentConstant {
  static const userId = "userId";
  static const imageFile = "imageFile";
  static const isFirstTime = "isFirstTime";
  static const isFromCatoonizer = "isFromCatoonizer";
  static const isFromEnhancer = "isFromEnhancer";
  static const isFromDenoiser = "isFromDenoiser";
  static const isFromAnime = "isFromAnime";
  static const isFromImageEnlarger = "isFromImageEnlarger";
  static const isFromImageUpscaler = "isFromImageUpscaler";
  static const isFromSharpener = "isFromSharpener";
  static const isFromFaceRetouch = "isFromFaceRetouch";
  static const isFromBGRemover = "isFromBGRemover";
  static const isFromColorizer = "isFromColorizer";
  static const isFromMyCollection = "isFromMyCollection";
  static const isFromHome = "isFromHome";
  static const capuredImage = "capuredImage";
  static const password = "password";
  static const myCollection = "myCollection";
}

getLogOut() {
  Get.offAllNamed(Routes.HOME);
}

String getYoutubeThumbnail({required String videoId}) {
  return "https://img.youtube.com/vi/$videoId/hqdefault.jpg";
}
