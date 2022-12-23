import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:samadhyan/Services/Firebase/backend.dart';
import 'package:samadhyan/Utilities/launch_a_url.dart';
import 'package:samadhyan/Utilities/send_email.dart';
import 'package:samadhyan/role_based/admin/dashboard.dart';
import 'package:samadhyan/role_based/event_coordinator/dashboard.dart';
import 'package:samadhyan/role_based/faculty/dashboard.dart';
import 'package:samadhyan/role_based/student/profile_page.dart';
import 'package:samadhyan/widgets/login_helpers.dart';

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
          accountName: null,
          decoration: BoxDecoration(
              image:
                  DecorationImage(image: OptimizedCacheImageProvider(urlLogo))),
          accountEmail: null,
        ),
        ListTile(
          leading: const Icon(Icons.account_box),

          subtitle: const Text("Details of your account"),
          onTap: () {
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
                  Get.to(() => const EventCoordinatorDashboard());
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
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
    ));
  }
}
