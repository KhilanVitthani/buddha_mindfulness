import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:yodo1mas/Yodo1MAS.dart';

import 'app/routes/app_pages.dart';
import 'constants/app_module.dart';
import 'constants/notification_service.dart';
import 'constants/sizeConstant.dart';

initFireBaseApp() async {
  await Firebase.initializeApp();
}

// @pragma('vm:entry-point')
// Future<void> myBackgroundMessageHandler(RemoteMessage message) async {
//   if (!isNullEmptyOrFalse(message)) {
//     await Firebase.initializeApp();
//     setUp();
//     await getIt<NotificationService>().init(flutterLocalNotificationsPlugin);
//     getIt<NotificationService>().showNotification(remoteMessage: message);
//   }
// }

bool isFlutterLocalNotificationInitialize = false;
final getIt = GetIt.instance;
GetStorage box = GetStorage();
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUp();
  await Firebase.initializeApp();
  await getIt<NotificationService>().init(flutterLocalNotificationsPlugin);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  Yodo1MAS.instance.init(
    "tenPXrtko1",
    true,
    (successful) {},
  );
  await GetStorage.init();
  FlutterNativeSplash.removeAfter(afterInit);
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
