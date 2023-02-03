import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:samadhyan/keys.dart';
import 'package:samadhyan/utilities/themes.dart';
import 'package:samadhyan/widgets/login_helpers.dart';
import 'package:samadhyan/constants.dart';
import 'package:sizer/sizer.dart';
import 'package:url_strategy/url_strategy.dart';

// Backend analytics
FirebaseAnalytics analytics = FirebaseAnalytics.instance;
Future<void> _messageHandler(RemoteMessage message) async {
  Fluttertoast.showToast(msg: "Opened through background message");
}

// Driver Program
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  await initializeApp();
  runApp(MyApp());
}

Future<void> initializeApp() async {
  await Firebase.initializeApp(
      options: kIsWeb
          ? const FirebaseOptions(
              apiKey: apiKey,
              authDomain: authDomain,
              databaseURL: databaseURL,
              projectId: projectId,
              storageBucket: storageBucket,
              messagingSenderId: messagingSenderId,
              appId: appId,
              measurementId: measurementId)
          : null);

  FirebaseAppCheck firebaseAppCheck = FirebaseAppCheck.instance;
  await firebaseAppCheck.activate(
      webRecaptchaSiteKey: webReCaptchaAppcheckSiteKey,
      androidDebugProvider: devMode);

  await FirebaseMessaging.instance
      .requestPermission(
    alert: true,
    announcement: true,
    badge: true,
    carPlay: true,
    criticalAlert: true,
    provisional: true,
    sound: true,
  )
      .then((value) async {
    if (value.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint("Permission Granted");
      await FirebaseMessaging.instance
          .getToken(vapidKey: vapidKey)
          .then((value) {
        // FirebaseMessaging Token resetting when  new login is performred
        userNewFCMToken = value!;
        devMode ? debugPrint(userNewFCMToken) : null;
      });
      FirebaseMessaging.onBackgroundMessage(_messageHandler);
    } else if (value.authorizationStatus == AuthorizationStatus.provisional) {
      debugPrint("Permission Provisional");
    } else if (value.authorizationStatus == AuthorizationStatus.denied) {
      debugPrint("Permission Denied");
      // FirebaseMessaging.instance.requestPermission();
    } else {
      debugPrint("Permission Unknown");
    }
  });

  if (kIsWeb) {
  } else {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    // Processing of Push Notifications

    // await MongoDB.connect();

    // await RemoteConfigService().initialize();
    // RemoteConfigService().showMainBanner
    //     ? print("Banner is on")
    //     : print("Banner is off");

    // firebaseAppCheck.getToken().then((value) {
    //   print(value);
    // });

    // firebaseAppCheck.installAppCheckProviderFactory(
    //     PlayIntegrityAppCheckProviderFactory.getInstance());
    // FirebaseAppCheck firebaseAppCheck = FirebaseAppCheck.instance;

    // firebaseAppCheck.activate();
    // firebaseAppCheck.getToken();
    // firebaseAppCheck.setTokenAutoRefreshEnabled(true);

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

  @override
  Widget build(BuildContext context) {
    return Sizer(builder:
        (BuildContext context, Orientation orientation, DeviceType deviceType) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: devMode,
        home: passwordLessSignIn(context),
        darkTheme: themeData,
        theme: themeData,
      );
    });
  }
}
