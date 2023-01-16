import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:samadhyan/Services/Firebase/backend.dart';
import 'package:samadhyan/Utilities/launch_a_url.dart';
import 'package:samadhyan/Utilities/send_email.dart';
import 'package:samadhyan/constants.dart';
import 'package:samadhyan/main.dart';
import 'package:samadhyan/role_based/admin/dashboard.dart';
import 'package:samadhyan/role_based/common/profile_page.dart';
import 'package:samadhyan/role_based/event_coordinator/dashboard.dart';
import 'package:samadhyan/role_based/faculty/dashboard.dart';
import 'package:samadhyan/widgets/login_helpers.dart';
import 'package:sizer/sizer.dart';

// https://student-activity-hub.flycricket.io/
String userDataPrivacyPolicy =
    "https://pages.flycricket.io/student-activity-hub-0/privacy.html";
String acceptableUsePolicy =
    "https://pages.flycricket.io/student-activity-hub-0/privacy.html";
String termsAndConditions =
    "https://pages.flycricket.io/student-activity-hub-0/privacy.html";

String disclaimer =
    "https://pages.flycricket.io/student-activity-hub-0/privacy.html";
String cookieManagementPolicy =
    "https://pages.flycricket.io/student-activity-hub-0/privacy.html";
String urlLogo =
    "https://upload.wikimedia.org/wikipedia/en/d/de/Rajasthan_Technical_University_logo.jpg";

String urlSite = "https://www.rtu.ac.in/";

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  var userRank = userSnapshot["rank"];
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 270,
      backgroundColor: Color.fromARGB(255, 239, 245, 255),
      child: ListView(
        primary: true,
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        children: [
          Container(
            height: 3.h,
          ),
          OptimizedCacheImage(
            imageUrl: urlLogo,
            imageRenderMethodForWeb: ImageRenderMethodForWeb.HttpGet,
            fit: BoxFit.fitWidth,
          ),
          // UserAccountsDrawerHeader(
          //   arrowColor: Colors.grey,
          //   accountName: null,
          //   decoration: BoxDecoration(
          //       image: DecorationImage(
          //     image:
          //     fit: BoxFit.fitWidth,
          //       )
          //   ),
          //   accountEmail: null,
          // ),
          !devMode
              ? SizedBox.shrink()
              : ListTile(
                  leading: const Icon(Icons.account_box),

                  subtitle: const Text("Details of your account"),
                  onTap: () async {
                    analytics.logEvent(name: "profile_page_opened");
                    Get.to(() => const ProfilePage());
                  },
                  // leading: Icon(Icons.account_circle),
                  title: const Text("Profile", overflow: TextOverflow.fade),
                ),
          userRank == 0
              ? ListTile(
                  leading: const Icon(Icons.admin_panel_settings),
                  subtitle: const Text("Admin control panel"),
                  onTap: () {
                    analytics.logEvent(name: "admin_dashboard_opened");
                    Get.to(() => const AdminDashboard());
                  },
                  // leading: Icon(Icons.account_circle),
                  title: const Text("Admin", overflow: TextOverflow.fade),
                )
              : Container(),
          userRank <= 1
              ? ListTile(
                  leading: const Icon(Icons.supervised_user_circle),
                  subtitle: const Text("Faculty control panel"),
                  onTap: () {
                    analytics.logEvent(name: "faculty_dashboard_opened");
                    Get.to(() => const FacultyDashboard());
                  },
                  // leading: Icon(Icons.account_circle),
                  title: const Text("Faculty", overflow: TextOverflow.fade),
                )
              : Container(),
          userRank <= 2
              ? ListTile(
                  leading: const Icon(Icons.admin_panel_settings),
                  subtitle: const Text("Event organizer control panel"),
                  onTap: () {
                    analytics.logEvent(
                        name: "event_coordinator_dashboard_opened");
                    Get.to(() => const EventCoordinatorDashboard());
                  },
                  // leading: Icon(Icons.account_circle),
                  title: const Text("Event organizer",
                      overflow: TextOverflow.fade),
                )
              : Container(),
          Divider(),
          devMode
              ? ExpansionTile(
                  title: const Text("Legal pages", overflow: TextOverflow.fade),
                  leading: const Icon(Icons.copyright_outlined),
                  // backgroundColor: Colors.grey[300],
                  children: [
                    ListTile(
                      onTap: () async => launchAUrl(userDataPrivacyPolicy),
                      title: const Text("Data privacy policy",
                          overflow: TextOverflow.fade),
                    ),
                    ListTile(
                      onTap: () async => launchAUrl(acceptableUsePolicy),
                      title: const Text("Fair use policy",
                          overflow: TextOverflow.fade),
                    ),
                    ListTile(
                      onTap: () async => launchAUrl(termsAndConditions),
                      title: const Text("Terms and conditions",
                          overflow: TextOverflow.fade),
                    ),
                    ListTile(
                      onTap: () async => launchAUrl(disclaimer),
                      title:
                          const Text("Disclaimer", overflow: TextOverflow.fade),
                    ),
                  ],
                )
              : Container(),
          ListTile(
            onTap: () async {
              analytics.logEvent(
                  name: "Tried to send feedback",
                  callOptions: AnalyticsCallOptions(global: true));
              sendEmail("rultimatrix@gmail.com");
            },
            leading: const Icon(Icons.feedback_rounded),
            title: const Text("Help & feedback", overflow: TextOverflow.fade),
            horizontalTitleGap: 16,
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            onTap: () async {
              analytics.logEvent(
                  name: "Tried to visit RTU website",
                  callOptions: AnalyticsCallOptions(global: true));
              launchAUrl(urlSite);
            },
            leading: const Icon(
              CupertinoIcons.link,
            ),
            title: const Text("Visit UD RTU KOTA Website",
                overflow: TextOverflow.fade),
            horizontalTitleGap: 16,
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            onTap: () {
              analytics.logEvent(
                  name: "Tried to log out",
                  callOptions: AnalyticsCallOptions(global: true));
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Are you sure you want to log out ?"),
                      actionsAlignment: MainAxisAlignment.spaceEvenly,
                      actions: [
                        TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: const Text("No")),
                        TextButton(
                            onPressed: () async {
                              Get.back();
                              signOut();
                            },
                            child: const Text("Yes"))
                      ],
                    );
                  });
            },
            leading: const Icon(
              CupertinoIcons.multiply_circle,
              color: Colors.red,
            ),
            title: const Text("Log Out", overflow: TextOverflow.fade),
            horizontalTitleGap: 16,
          ),
        ],
      ),
    );
  }
}
