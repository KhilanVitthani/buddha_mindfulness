import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
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
  ];
}
