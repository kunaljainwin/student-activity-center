import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:samadhyan/Common%20Screens/drawer.dart';
import 'package:samadhyan/Utilities/launch_a_url.dart';
import 'package:samadhyan/Utilities/send_email.dart';
import 'package:samadhyan/widgets/login_helpers.dart';

class ProfileAvatar extends StatelessWidget {
  final num level;
  const ProfileAvatar({
    Key? key,
    required this.level,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      enableFeedback: true,
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return Center(
                child: Dialog(
                  insetAnimationDuration: Duration(seconds: 1),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Container(
                          height: 40,
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  icon: Icon(
                                    CupertinoIcons.multiply,
                                    color: Colors.black87,
                                  ))
                            ],
                          )),
                      ListTile(
                          onTap: () {},
                          leading: CircleAvatar(
                            radius: 20,
                            child: OptimizedCacheImage(
                              imageUrl: userSnapshot["imageurl"],
                            ),
                          ),
                          title: Text(userSnapshot["nickname"]),
                          trailing: Icon(Icons.arrow_downward)),
                      Divider(
                        thickness: 1,
                      ),
                      ListTile(
                        onTap: () {},
                        title: Text("Settings"),
                        leading: Icon(Icons.settings_outlined),
                      ),
                      ListTile(
                        onTap: () async {
                          sendEmail("rultimatrix@gmail.com");
                        },
                        leading: Icon(CupertinoIcons.question_circle),
                        title: Text("Help and Feedback"),
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () async =>
                                launchAUrl(userDataPrivacyPolicy),
                            child: Text(
                              "Privacy policy",
                              textScaleFactor: 0.9,
                              style: TextStyle(color: Colors.black54),
                            ),
                          ),
                          InkWell(
                            onTap: () async => launchAUrl(termsAndConditions),
                            child: Text(
                              "Terms of Service",
                              textScaleFactor: 0.9,
                              style: TextStyle(color: Colors.black54),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      )
                    ],
                  ),
                ),
              );
            });
      },
      child: OptimizedCacheImage(
        imageUrl: userSnapshot["imageurl"],
        imageBuilder: (context, image) {
          return CircleAvatar(
            radius: 17,
            backgroundColor: Colors.white,
            foregroundImage: image,
          );
        },
        placeholder: (context, s) {
          return CircleAvatar(
            radius: 17,
            backgroundColor: Color.fromRGBO(Random().nextInt(250),
                Random().nextInt(250), Random().nextInt(250), 0.9),
            child: Text(
              userSnapshot["nickname"] ?? "",
              style: TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}
