import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:yodo1mas/Yodo1MAS.dart';

import 'app/routes/app_pages.dart';
import 'constants/app_module.dart';
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
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUp();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  OneSignal.shared.setAppId("db2562c3-bf37-41be-b795-7ae4a76f4fe3");

// The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    print("Accepted permission: $accepted");
  });
  OneSignal.shared.setNotificationWillShowInForegroundHandler(
      (OSNotificationReceivedEvent event) {
    // Will be called whenever a notification is receiv ed in foreground
    // Display Notification, pass null param for not displaying the notification
    event.complete(event.notification);
  });
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
