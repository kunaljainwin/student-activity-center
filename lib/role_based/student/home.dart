// MY HOME PAGE Stateful Widget
import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:samadhyan/constants.dart';
import 'package:samadhyan/role_based/student/achievements.dart';
import 'package:samadhyan/role_based/student/drawer.dart';
import 'package:samadhyan/role_based/student/edit_profile.dart';
import 'package:samadhyan/role_based/student/event_details.dart';
import 'package:samadhyan/role_based/student/events.dart';
import 'package:samadhyan/role_based/student/login_page.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:samadhyan/services/firebase/in_app_messaging.dart';
import 'package:samadhyan/utilities/is_profile_complete.dart';
import 'package:samadhyan/widgets/login_helpers.dart';
import 'package:samadhyan/widgets/profile_widget.dart';
import 'package:samadhyan/widgets/special_splash.dart';
import 'package:samadhyan/Utilities/learn_more.dart';
import 'package:samadhyan/Utilities/compute_level.dart';
import 'package:samadhyan/services/Firebase/dynamic_links_util.dart'
    as dynamic_links_util;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  // local variables
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(seconds: 60))
        ..repeat();
  final ScrollController _scrollController = ScrollController();

  num totalVisits = userSnapshot["attendance"];
  bool isLearnMoreVisible = true;

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

// initState
  @override
  void initState() {
    super.initState();
    Level.computeLevel(userSnapshot["attendance"]);
    // FirebaseMessaging Toker resetting when  new login is performred

    // Server send message Processing on app operm
    FirebaseMessaging.onMessage.listen((RemoteMessage event) async {
      debugPrint("receieved message ${event.toString()}");
      await MessagingService.initialize(onSelectNotification).then((value) {
        debugPrint("receieved message ${value.toString()}");
        MessagingService.onMessageOpenedApp.listen(_pageOpenForOnLaunch(event));
      });
    });
    if (!kIsWeb) {
      dynamic_links_util.DynamicLinks.initDynamicLinks();
    }
    // Profile Edit Dialog after some time on home screen
    isProfileComplete(userSnapshot) || !devMode
        ? null
        : Timer(const Duration(seconds: 4), () {
            showDialog(
                context: context,
                builder: (context) {
                  return const EditProfile();
                });
          });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    // was Giving error
    // _scrollController.dispose();
    super.dispose();
  }

  // variables
  @override
  Widget build(BuildContext context) {
    var imageUrl2 =
        "https://firebasestorage.googleapis.com/v0/b/visitcounter-fef16.appspot.com/o/ezgif.com-gif-maker%20(1).jpg?alt=media&token=f6a09471-bbd3-4298-a694-7ef920d9a5b0";

    return Scaffold(
        body: NestedScrollView(
          controller: _scrollController,
          floatHeaderSlivers: true,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              appbarMain(context),
            ];
          },
          body: SingleChildScrollView(
            child: Column(
              children: [
                // titleBox("Registered events"),
                PaginateFirestore(
                    header: const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 80,
                      ),
                    ),
                    scrollController: _scrollController,
                    itemsPerPage: 2,
                    onEmpty: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: OptimizedCacheImage(
                                fit: BoxFit.fitWidth, imageUrl: imageUrl2),
                          ),
                          const Text(
                            "No Events Found",
                            textScaleFactor: 1.5,
                          )
                        ],
                      ),
                    ),
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
                        .where("registered", arrayContains: userName),
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
      flexibleSpace: Wrap(
        alignment: WrapAlignment.start,
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            leadingWidth: 48,
            centerTitle: true,
            title: const Text(appName),
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
                color: const Color.fromRGBO(255, 255, 255, 1),
                border: Border.all(color: Colors.blueGrey.shade400),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                // autofocus: true,
                // enabled: true,
                // enableFeedback: true,
                onTap: () => Get.to(() => AchievementsPage(
                      level: Level.level,
                      totalVisits: totalVisits,
                      userData: userSnapshot,
                    )),
                leading: GestureDetector(
                  onTap: () {
                    _controller.isAnimating
                        ? _controller.stop()
                        : _controller.repeat();
                  },
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) => Transform.rotate(
                      angle: _controller.value * 2 * math.pi,
                      child: QrImage(
                          padding: const EdgeInsets.all(3), data: userEmail),
                    ),
                  ),
                ),
                title: Text("Level ${Level.level.toString()}"),
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
                        Text(
                            "${totalVisits - Level.before}/${Level.after} points"),
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
                              "${Level.after - totalVisits + Level.before} more to Level up",
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
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.white, Colors.grey.shade50])),
                  child: ListTile(
                    enableFeedback: true,
                    onTap: () => learnMore(),
                    leading: const Heading(),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  BottomAppBar babMain() {
    return BottomAppBar(
      elevation: 8,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        SplashContainer(
          wid: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [Icon(Icons.synagogue_outlined), Text("  Home ")],
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
              : debugPrint("Login for this feature"),
          wid: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [Icon(Icons.leaderboard_outlined), Text(" Events")],
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child:
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
        Text(
          "Were would you like to go now ?",
        ),
        Text(
          "Learn how to use the app",
          style: TextStyle(color: Colors.blue),
        ),
      ]),
    );
  }
}
// 45K8Q~~dZW95KGKLJS5njW4p8Ykgwz4NurFAyaia -secret value