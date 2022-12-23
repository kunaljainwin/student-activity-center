import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:samadhyan/Utilities/launch_a_url.dart';
import 'package:samadhyan/Utilities/send_email.dart';
import 'package:samadhyan/role_based/student/drawer.dart';
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
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                              gradient: LinearGradient(
                                  colors: [
                                    Colors.blue,
                                    Colors.primaries[Random()
                                        .nextInt(Colors.primaries.length)],
                                    Colors.primaries[Random()
                                        .nextInt(Colors.primaries.length)]
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  stops: const [0.1, 0.5, 0.9])),
                          height: 40,
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  icon: const Icon(
                                    CupertinoIcons.multiply,
                                    color: Colors.black87,
                                  ))
                            ],
                          )),
                      ListTile(
                          onTap: () {},
                          leading: CircleAvatar(
                            radius: 24,
                            child: OptimizedCacheImage(
                              imageUrl: userSnapshot["imageurl"],
                              fit: BoxFit.fill,
                              errorWidget: ((context, url, error) {
                                return const Icon(CupertinoIcons.person);
                              }),
                              imageBuilder: (context, image) {
                                return CircleAvatar(
                                  radius: 20,
                                  foregroundImage: image,
                                );
                              },
                            ),
                          ),
                          title: Text(userSnapshot["nickname"]),
                          trailing: const Icon(Icons.arrow_downward)),
                      const Divider(
                        thickness: 1,
                      ),
                      ListTile(
                        onTap: () {},
                        title: const Text("Settings"),
                        leading: const Icon(Icons.settings_outlined),
                      ),
                      ListTile(
                        onTap: () async {
                          sendEmail("rultimatrix@gmail.com");
                        },
                        leading: const Icon(CupertinoIcons.question_circle),
                        title: const Text("Help and Feedback"),
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () async =>
                                launchAUrl(userDataPrivacyPolicy),
                            child: policyText("Privacy policy"),
                          ),
                          InkWell(
                            onTap: () async => launchAUrl(termsAndConditions),
                            child: policyText("Terms of Service"),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 6,
                      )
                    ],
                  ),
                ),
              );
            });
      },
      child: OptimizedCacheImage(
        imageUrl: userSnapshot["imageurl"],
        fit: BoxFit.fill,
        errorWidget: ((context, url, error) {
          return const Icon(CupertinoIcons.person);
        }),
        imageBuilder: (context, image) {
          return CircleAvatar(
            radius: 17,
            foregroundImage: image,
          );
        },
      ),
    );
  }

  Text policyText(String text) {
    return Text(
      text,
      textScaleFactor: 0.9,
      style: const TextStyle(color: Colors.black54),
    );
  }
}
