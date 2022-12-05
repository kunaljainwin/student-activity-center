import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:paginate_firestore/widgets/empty_display.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:samadhyan/Common%20Screens/drawer.dart';
import 'package:samadhyan/Services/mongo.dart';
import 'package:samadhyan/Common%20Screens/event_details.dart';
import 'package:samadhyan/Services/Firebase/dynamic_links_util.dart';
import 'package:samadhyan/Services/Firebase/in_app_messaging.dart';
import 'package:samadhyan/Utilities/compute_level.dart';
import 'package:samadhyan/widgets/login_helpers.dart';
import 'package:samadhyan/Common%20Screens/achievements.dart';
import 'package:samadhyan/Services/Firebase/backend.dart';
import 'package:samadhyan/Utilities/learn_more.dart';
import 'package:samadhyan/constants.dart';
import 'package:samadhyan/widgets/login_helpers.dart';
import 'package:samadhyan/Common%20Screens/login_page.dart';
import 'package:http/http.dart' as http;
import 'package:samadhyan/widgets/profile_widget.dart';
import 'package:samadhyan/widgets/special_splash.dart';
import 'package:samadhyan/widgets/title_box.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Common Screens/events.dart';
import 'Utilities/is_today.dart';

// Backend analytics
FirebaseAnalytics analytics = FirebaseAnalytics as FirebaseAnalytics;
Future<void> _messageHandler(RemoteMessage message) async {
  print("Opened through background message");
}

Future onSelectNotification(String? payload) async {
  debugPrint("onSelectNotification");
  debugPrint(payload);
}

// Push Notifications
_pageOpenForOnLaunch(RemoteMessage remoteMessage) {
  final Map<String, dynamic> message = remoteMessage.data;
  onSelectNotification(jsonEncode(message));
  MessagingService.invokeLocalNotification(remoteMessage);
}

// Driver Program
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();
  await MongoDB.connect();
  kIsWeb ? null : FirebaseMessaging.onBackgroundMessage(_messageHandler);
  runApp(const MyApp());
  // Processing of Push Notifications
  if (!kIsWeb) {
    // MessagingService.openInitialScreenFromMessage();
    FirebaseMessaging.onMessage.listen((RemoteMessage event) async {
      print("receieved message" + event.toString());
      await MessagingService.initialize(onSelectNotification).then((value) {
        print("receieved message" + value.toString());
        MessagingService.onMessageOpenedApp.listen(_pageOpenForOnLaunch(event));
      });
    });
    DynamicLinks.initDynamicLinks();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      useInheritedMediaQuery: true,
      smartManagement: SmartManagement.keepFactory,
      title: 'locationsource',
      debugShowCheckedModeBanner: devMode,
      home: passwordLessSignIn(context),
      theme: ThemeData(
        primaryColor: Colors.white,
        primarySwatch: Colors.grey,
        useMaterial3: true,
        textTheme: GoogleFonts.robotoFlexTextTheme(),
        textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
                textStyle:
                    TextStyle(fontFamily: GoogleFonts.lato().fontFamily))),
        dialogTheme: DialogTheme(
            alignment: const Alignment(0, -0.5),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
        outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
                textStyle: TextStyle(color: Colors.black))),
      ),
    );
  }
}

// MY HOME PAGE Stateful Widget
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // local variables

  num totalVisits = userSnapshot["attendance"];

  bool isLearnMoreVisible = false;

// initState
  @override
  void initState() {
    super.initState();
    Level.computeLevel(userSnapshot["attendance"]);
    // FirebaseMessaging Toker resetting when  new login is performred
    kIsWeb
        ? null
        : FirebaseMessaging.instance.getToken().then((value) {
            userNewFCMToken = value!;
            print(userNewFCMToken);
          });

    // Server send message Processing on app operm
    FirebaseMessaging.onMessage.listen((RemoteMessage event) async {
      print("receieved message" + event.toString());
      await MessagingService.initialize(onSelectNotification).then((value) {
        print("receieved message" + value.toString());
        MessagingService.onMessageOpenedApp.listen(_pageOpenForOnLaunch(event));
      });
    });
  }

  // variables
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              appbarMain(context),
            ];
          },
          body: SingleChildScrollView(
            child: Column(
              children: [
                titleBox("Registered events"),
                PaginateFirestore(
                    onEmpty: Text('Not Registered for Event'),
                    shrinkWrap: true,
                    isLive: true,
                    itemBuilder: (context, listSnapshot, index) {
                      return InkWell(
                          child:
                              cardBuilder(context, listSnapshot[index], index),
                          onTap: () => Get.to(() => EventDetails(
                                event: listSnapshot[index],
                              )));
                    },
                    query: FirebaseFirestore.instance
                        .collection("contests")
                        .where("registered",
                            arrayContains: userSnapshot["useremail"]),
                    itemBuilderType: PaginateBuilderType.listView),
              ],
            ),
          ),
        ),
        drawer: const MyDrawer(),
        bottomNavigationBar: babMain());
  }

  // local widgets
  SliverAppBar appbarMain(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: true,
      // pinned: true,
      floating: true,
      snap: true,
      expandedHeight: 180.0,
      // snap: true,
      // stretch: false,
      // pinned: true,
      // floating: true,

      backgroundColor: Colors.white,
      flexibleSpace: Wrap(
        alignment: WrapAlignment.start,
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            leadingWidth: 48,
            centerTitle: true,
            title: const Text(app_name),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: isLoggedIn
                    ? CircleAvatar(
                        radius: 17,
                        child: ProfileAvatar(
                          level: Level.level,
                        ),
                      )
                    : SplashContainer(
                        wid: const Text(
                          "Login",
                          textScaleFactor: 1.8,
                          style: TextStyle(color: Colors.black54),
                        ),
                        onTap: () => Get.to(() => const LoginPage()),
                        splashRadius: 100),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 1),
                border: Border.all(color: Colors.blueGrey.shade400),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                onTap: () => Get.to(() => AchievementsPage(
                      level: Level.level,
                      totalVisits: totalVisits,
                      userData: userSnapshot,
                    )),
                leading:
                    QrImage(padding: const EdgeInsets.all(0), data: userEmail),
                // leading: Container(
                //   height: 50,
                //   width: 50,
                //   decoration: BoxDecoration(
                //     image: DecorationImage(
                //         image: CachedNetworkImageProvider(
                //             "https://firebasestorage.googleapis.com/v0/b/visitcounter-fef16.appspot.com/o/clipart614884.png?alt=media&token=3e373aa8-6e4a-4704-a58e-308144a53594")),
                //     shape: BoxShape.rectangle,
                //     borderRadius: BorderRadius.all(Radius.circular(10)),
                //   ),
                // ),
                title: Text("Level " + Level.level.toString()),
                trailing: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                    )),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: LinearProgressIndicator(
                        value: (totalVisits - Level.before) / Level.after,
                        backgroundColor: Colors.blueGrey.shade400,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.orangeAccent),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text((totalVisits - Level.before).toString() +
                            "/" +
                            (Level.after).toString() +
                            " points"),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(
                                color:
                                    Colors.deepOrange.shade800.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(
                              (Level.after - totalVisits + Level.before)
                                      .toString() +
                                  " more to Level up",
                              textScaleFactor: 0.8,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          isLearnMoreVisible
              ? Container(
                  child: ListTile(
                    enableFeedback: true,
                    onTap: () => learnMore(),
                    leading: const Heading(),
                  ),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.white, Colors.grey.shade50])),
                )
              : Container(),
        ],
      ),
    );
  }

  BottomAppBar babMain() {
    return BottomAppBar(
      elevation: 10,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        SplashContainer(
          wid: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.synagogue_outlined),
              const Text("     Home    ")
            ],
          ),
          splashRadius: 40,
        ),
        SplashContainer(
          wid: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.workspace_premium_outlined),
              Text("Notices")
            ],
          ),
          onTap: () async {},
          splashRadius: 40,
        ),
        SplashContainer(
          onTap: () => isLoggedIn
              ? Get.to(() => const Events())
              : print("Login for this feature"),
          wid: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.leaderboard_outlined),
              const Text("Events")
            ],
          ),
          splashRadius: 40,
        ),
      ]),
    );
  }
}

// Component of  home page
class Heading extends StatelessWidget {
  const Heading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Text("Total Registerations   " +
        //     userSnapshot['registerations'].toString()),
        // Text("Total Attendance   " + userSnapshot['attendance'].toString()),
        const Text(
          "Were would you like to go now?",
          textScaleFactor: 1.1,
        ),
        const Text(
          "Learn how this app works",
          textScaleFactor: 0.9,
          style: TextStyle(color: Colors.blue),
        ),
      ]),
    );
  }
}
// 45K8Q~~dZW95KGKLJS5njW4p8Ykgwz4NurFAyaia -secret value