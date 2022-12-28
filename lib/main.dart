import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';

import 'package:samadhyan/widgets/login_helpers.dart';

import 'package:samadhyan/constants.dart';

// Backend analytics
FirebaseAnalytics analytics = FirebaseAnalytics as FirebaseAnalytics;
Future<void> _messageHandler(RemoteMessage message) async {
  debugPrint("Opened through background message");
}

// Driver Program
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeApp();
  runApp(const MyApp());
}

Future<void> initializeApp() async {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  // await MongoDB.connect();
  await Firebase.initializeApp();
  // await RemoteConfigService().initialize();
  // RemoteConfigService().showMainBanner
  //     ? print("Banner is on")
  //     : print("Banner is off");
  FirebaseAppCheck firebaseAppCheck = FirebaseAppCheck.instance;

  firebaseAppCheck.activate();
  firebaseAppCheck.getToken();
  firebaseAppCheck.setTokenAutoRefreshEnabled(true);
  kIsWeb ? null : FirebaseMessaging.onBackgroundMessage(_messageHandler);

  // Processing of Push Notifications

  if (!kIsWeb) {
    await FirebaseMessaging.instance.getToken().then((value) {
      userNewFCMToken = value!;
      debugPrint(userNewFCMToken);
    });
    // MessagingService.openInitialScreenFromMessage();
    // FirebaseMessaging.onMessage.listen((RemoteMessage event) async {
    //   print("receieved message" + event.toString());
    //   await MessagingService.initialize(onSelectNotification).then((value) {
    //     print("receieved message" + value.toString());
    //     MessagingService.onMessageOpenedApp.listen(_pageOpenForOnLaunch(event));
    //   });
    // });

  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: devMode,
      home: passwordLessSignIn(context),
      theme: ThemeData(
        // primaryColor: Colors.white,
        useMaterial3: true,
        // textTheme: GoogleFonts.robotoFlexTextTheme(),
        // textButtonTheme: TextButtonThemeData(
        //     style: TextButton.styleFrom(
        //         textStyle:
        //             TextStyle(fontFamily: GoogleFonts.lato().fontFamily))),
        // dialogTheme: DialogTheme(
        //     alignment: const Alignment(0, -0.5),
        //     shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(10))),
        // outlinedButtonTheme: OutlinedButtonThemeData(
        //     style: OutlinedButton.styleFrom(
        //         textStyle: const TextStyle(color: Colors.black))),
      ),
    );
  }
}
