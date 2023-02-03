// MY HOME PAGE Stateful Widget
import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samadhyan/constants.dart';
import 'package:samadhyan/role_based/common/achievements.dart';
import 'package:samadhyan/role_based/common/additional_info.dart';
import 'package:samadhyan/role_based/common/chat_gpt.dart';
import 'package:samadhyan/role_based/common/drawer.dart';
import 'package:samadhyan/role_based/common/event_details.dart';
import 'package:samadhyan/role_based/common/events.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:samadhyan/role_based/common/tweets.dart';
import 'package:samadhyan/role_based/empty_screen.dart';
import 'package:samadhyan/services/firebase/in_app_messaging.dart';
import 'package:samadhyan/utilities/compute_level.dart';
import 'package:samadhyan/utilities/is_profile_complete.dart';
import 'package:samadhyan/widgets/grid_card.dart';
import 'package:samadhyan/widgets/login_helpers.dart';
import 'package:samadhyan/widgets/profile_widget.dart';
import 'package:samadhyan/widgets/special_splash.dart';
import 'package:samadhyan/Utilities/learn_more.dart';
import 'package:samadhyan/services/Firebase/dynamic_links_util.dart'
    as dynamic_links_util;
import 'package:samadhyan/widgets/title_box.dart';
import 'package:sizer/sizer.dart';

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

  final List<Map<String, Object>> _gridItems = [
    {
      "title": "Events",
      "svg_icon": "lib/assets/event-icon.svg",
      "color": Colors.blue,
      "route": Events(
        query: FirebaseFirestore.instance.collection("contests"),
        title: 'Explore events',
      ),
    },
    {
      "title": "Achievements",
      "svg_icon": "lib/assets/achievement-award-medal-icon.svg",
      "color": Colors.green,
      "route": AchievementsPage(userData: userSnapshot, level: Level.level),
    },
    {
      "title": "My events",
      "svg_icon": "lib/assets/event-calendar-icon.svg",
      "color": Colors.red,
      "route": Events(
        query: FirebaseFirestore.instance
            .collection("contests")
            .where("registered", arrayContains: userEmail),
        title: 'Registered for..',
      ),
    },
    {
      "title": "Ai chat bot",
      "svg_icon": "lib/assets/openAI_logo.svg",
      "color": Colors.red,
      "route": const ChatPage()
    },
    {
      "title": "Notices",
      "svg_icon": "lib/assets/notices-board-icon.svg",
      "color": Colors.red,
      "route": const EmptyScreen()
    },
    {
      "title": "Request Feature",
      "svg_icon": "lib/assets/made-in-india-icon.svg",
      "color": Colors.red,
      "route": const EmptyScreen()
    },
    {
      "title": "Tweets & News",
      "svg_icon": "lib/assets/made-in-india-icon.svg",
      "color": Colors.red,
      "route": kIsWeb ? EmptyScreen() : TweetsPage()
    },
    {
      "title": "Global Chat",
      "svg_icon": "lib/assets/made-in-india-icon.svg",
      "color": Colors.red,
      "route": EmptyScreen()
    },
  ];

  // variables
  @override
  Widget build(BuildContext context) {
    var imageUrl2 =
        "https://firebasestorage.googleapis.com/v0/b/visitcounter-fef16.appspot.com/o/ezgif.com-gif-maker%20(1).jpg?alt=media&token=f6a09471-bbd3-4298-a694-7ef920d9a5b0";

    return Scaffold(
      body: NestedScrollView(
        // controller: _scrollController,
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            appbarMain(context),
          ];
        },
        body: ListView(
          shrinkWrap: true,
          children: [
            GridView.count(
              controller: _scrollController,
              shrinkWrap: true,
              crossAxisCount: SizerUtil.orientation == Orientation.portrait
                  ? 2
                  : (100.w / 350).round(),
              children: _gridItems
                  .map((e) => Padding(
                        padding: const EdgeInsets.all(12),
                        child: Card(
                          color: Colors.teal,
                          child: GridCard(
                            e: e,
                          ),
                        ),
                      ))
                  .toList(),
            ),
            titleBox("Registered events"),
            PaginateFirestore(
                // scrollController: _scrollController,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                onEmpty: Image.asset(
                  "lib/assets/no_events.png",
                  isAntiAlias: true,
                  alignment: Alignment.topCenter,
                ),
                itemBuilder: (context, listSnapshot, index) {
                  return InkWell(
                      key: Key(index.toString()),
                      child: cardBuilder(context, listSnapshot[index], index),
                      onTap: () => Get.to(() => EventDetails(
                            event: listSnapshot[index],
                          )));
                },
                query: FirebaseFirestore.instance
                    .collection("contests")
                    .where("registered", arrayContains: userEmail)
                    .orderBy("endTime", descending: true),
                itemBuilderType: PaginateBuilderType.listView),
          ],
        ),
        // body: SingleChildScrollView(
        //   child: Column(
        //     children: [
        //       // titleBox("Registered events"),
        //       PaginateFirestore(
        //           header: const SliverToBoxAdapter(
        //             child: SizedBox(
        //               height: 80,
        //             ),
        //           ),
        //           scrollController: _scrollController,
        //           itemsPerPage: 2,
        //           onEmpty: Padding(
        //             padding: const EdgeInsets.all(8.0),
        //             child: Column(
        //               mainAxisAlignment: MainAxisAlignment.start,
        //               children: [
        //                 const SizedBox(
        //                   height: 30,
        //                 ),
        //                 Padding(
        //                     padding: EdgeInsets.symmetric(horizontal: 20.w),
        //                     child: Image.asset("lib/assets/no_events.png")),
        //                 const Text(
        //                   "No Events Found",
        //                   textScaleFactor: 1.5,
        //                 )
        //               ],
        //             ),
        //           ),
        //           shrinkWrap: true,
        //           isLive: true,
        //           itemBuilder: (context, listSnapshot, index) {
        //             return InkWell(
        //                 child:
        //                     cardBuilder(context, listSnapshot[index], index),
        //                 onTap: () => Get.to(() => EventDetails(
        //                       event: listSnapshot[index],
        //                     )));
        //           },
        //           query: FirebaseFirestore.instance
        //               .collection("contests")
        //               .where("registered", arrayContains: userName),
        //           itemBuilderType: PaginateBuilderType.listView),
        //     ],
        //   ),
        // ),
      ),
      drawer: const MyDrawer(),
      // bottomNavigationBar: babMain()
    );
  }

  // local widgets
  SliverAppBar appbarMain(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      // pinned: true,
      leadingWidth: 180,
      leading: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        child: GestureDetector(
          onTap: () => Scaffold.of(context).openDrawer(),
          child: Container(
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(15)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.menu),
                SizedBox(
                  width: 5,
                ),
                Text(
                  appName,
                  textScaleFactor: 1.1,
                  style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.lato().fontFamily),
                )
              ],
            ),
          ),
        ),
      ),
      floating: true,
      snap: true,
      expandedHeight: 160.0,
      backgroundColor: Colors.white,
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
            // centerTitle: true,
            // title: const Text(appName),
            actions: [
              Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: CircleAvatar(
                    radius: 17,
                    child: ProfileAvatar(
                      level: Level.level,
                    ),
                  ))
            ],
          ),
          Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(255, 255, 255, 1),
                  border: Border.all(color: Colors.blueGrey.shade400),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  onTap: () => Get.to(() => AchievementsPage(
                        level: Level.level,
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
                  title: Text(
                    "Level ${Level.level.toString()}",
                    textScaleFactor: 1.1,
                  ),
                  trailing: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.arrow_forward_ios,
                      )),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: LinearProgressIndicator(
                          value: (totalVisits - Level.before) / Level.after,
                          backgroundColor: Colors.blueGrey.shade400,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.orangeAccent),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Text(
                          //   "${totalVisits - Level.before}/${Level.after} points",
                          //   softWrap: true,
                          //   overflow: TextOverflow.clip,
                          // ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 3),
                              decoration: BoxDecoration(
                                  color: Colors.deepOrange.shade800
                                      .withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(16)),
                              child: Text(
                                "${Level.after - totalVisits + Level.before} more to Level up",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.5),
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
          ),
          isLearnMoreVisible
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.white, Colors.grey.shade50])),
                  child: ListTile(
                    enableFeedback: true,
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
              ? Get.to(() => Events(
                    query: FirebaseFirestore.instance.collection("contests"),
                    title: 'Explore events',
                  ))
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
    return TextButton(
      child: const Text(
        "Learn how to use the app",
        textAlign: TextAlign.center,
        textScaleFactor: 1.1,
        style: TextStyle(color: Colors.blue),
      ),
      onPressed: () => learnMore(),
    );
  }
}
// 45K8Q~~dZW95KGKLJS5njW4p8Ykgwz4NurFAyaia -secret value
