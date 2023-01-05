import 'package:get/get.dart';

import '../modules/all_post_screen/bindings/all_post_screen_binding.dart';
import '../modules/all_post_screen/views/all_post_screen_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/like_screen/bindings/like_screen_binding.dart';
import '../modules/like_screen/views/like_screen_view.dart';
import '../modules/show_post_page/bindings/show_post_page_binding.dart';
import '../modules/show_post_page/views/show_post_page_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SHOW_POST_PAGE,
      page: () => const ShowPostPageView(),
      binding: ShowPostPageBinding(),
    ),
    GetPage(
      name: _Paths.LIKE_SCREEN,
      page: () => const LikeScreenView(),
      binding: LikeScreenBinding(),
    ),
    GetPage(
      name: _Paths.ALL_POST_SCREEN,
      page: () => const AllPostScreenView(),
      binding: AllPostScreenBinding(),
    ),
  ];
}
