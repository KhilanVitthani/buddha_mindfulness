import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:yodo1mas/Yodo1MAS.dart';

import 'app/routes/app_pages.dart';
import 'constants/app_module.dart';

final getIt = GetIt.instance;
GetStorage box = GetStorage();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await GetStorage.init();
  Yodo1MAS.instance.init(
    "YXFF80QLsa",
    true,
    (successful) {},
  );
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.removeAfter(afterInit);
  setUp();
  runApp(
    GetMaterialApp(
      theme: ThemeData(
        fontFamily: 'Lato',
      ),
      debugShowCheckedModeBanner: false,
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}

Future<void> afterInit(_) async {
  await Future.delayed(Duration(microseconds: 1));
}
