import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:samadhyan/Services/Firebase/backend.dart';
import 'package:samadhyan/Type%20Of%20User/Faculty/dashboard.dart';
import 'package:samadhyan/Utilities/launch_a_url.dart';
import 'package:samadhyan/Utilities/send_email.dart';
import 'package:samadhyan/widgets/login_helpers.dart';

import '../Type Of User/Admin/dashboard.dart';
import '../Type Of User/Event Coordinator/dashboard.dart';

String userDataPrivacyPolicy =
    "https://docs.google.com/document/d/1aaPMtWuy6lPhNQIFFyqSIHop_nVGjtLx_mpNoLZaA6Q/edit?usp=sharing";
String acceptableUsePolicy =
    "https://docs.google.com/document/d/1TPAKXv3jx1iuyWM-11l1gmHpX1UVvCMNmKPof1b7dF8/edit?usp=sharing";
String termsAndConditions =
    "https://docs.google.com/document/d/1MCdPqdsA5Gumml20loXSSdWC0Bc2UArWLZhXtzNX2jg/edit?usp=sharing";

String disclaimer =
    "https://docs.google.com/document/d/1TsCS2vTinrPagNi6EL5yVYNhuZYpg5C2rp4CorbuREU/edit?usp=sharing";
String cookieManagementPolicy =
    "https://docs.google.com/document/d/1KLvEENayF9wu0Ox026uQaTW-fN19oHybiVlqqm6gdMU/edit?usp=sharing";
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
        child: ListView(
      primary: true,
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      children: [
        UserAccountsDrawerHeader(
          arrowColor: Colors.grey,
          decoration: BoxDecoration(
              // gradient: LinearGradient(
              //     colors: [Colors.lightBlue, Colors.transparent]),
              // backgroundBlendMode: BlendMode.multiply,
              // boxShadow: [BoxShadow(color: Colors.brown)],

              // shape: BoxShape.circle,

              ),
          accountName: null,
          currentAccountPicture: OptimizedCacheImage(imageUrl: urlLogo),
          accountEmail: null,
        ),
        userRank == 0
            ? ListTile(
                leading: Icon(Icons.admin_panel_settings),
                subtitle: Text("Admin control panel"),
                onTap: () {
                  Get.to(() => AdminDashboard());
                },
                // leading: Icon(Icons.account_circle),
                title: const Text("Admin", overflow: TextOverflow.fade),
              )
            : Container(),
        userRank <= 1
            ? ListTile(
                leading: Icon(Icons.supervised_user_circle),
                subtitle: Text("Faculty control panel"),
                onTap: () {
                  Get.to(() => FacultyDashboard());
                },
                // leading: Icon(Icons.account_circle),
                title: const Text("Faculty", overflow: TextOverflow.fade),
              )
            : Container(),
        userRank <= 2
            ? ListTile(
                leading: Icon(Icons.admin_panel_settings),
                subtitle: Text("Event organizer control panel"),
                onTap: () {
                  Get.to(() => EventCoordinatorDashboard());
                },
                // leading: Icon(Icons.account_circle),
                title:
                    const Text("Event organizer", overflow: TextOverflow.fade),
              )
            : Container(),
        ExpansionTile(
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
              title: const Text("Fair use policy", overflow: TextOverflow.fade),
            ),
            ListTile(
              onTap: () async => launchAUrl(termsAndConditions),
              title: const Text("Terms and conditions",
                  overflow: TextOverflow.fade),
            ),
            ListTile(
              onTap: () async => launchAUrl(disclaimer),
              title: const Text("Disclaimer", overflow: TextOverflow.fade),
            ),
          ],
        ),
        ListTile(
          onTap: () async {
            sendEmail("rultimatrix@gmail.com");
          },
          leading: const Icon(Icons.feedback_rounded),
          title: const Text("Help & feedback", overflow: TextOverflow.fade),
          horizontalTitleGap: 16,
        ),
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
          onTap: () async {
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
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
          onTap: () {
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
                            signOut();
                            Get.back();
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
    ));
  }
}
