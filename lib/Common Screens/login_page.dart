import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:samadhyan/Utilities/launch_a_url.dart';
import 'package:samadhyan/constants.dart';
import 'package:samadhyan/Services/Firebase/backend.dart';
import 'package:samadhyan/main.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Student activity center',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'presents you',
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
                Text(
                  'Rtu Events',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                ElevatedButton.icon(
                    onPressed: () async {
                      try {
                        await signInWithGoogle();
                      } catch (e) {
                        Fluttertoast.showToast(msg: e.toString());
                      }
                    },
                    style: ElevatedButton.styleFrom(primary: Colors.white),
                    icon: SizedBox(
                        height: 30,
                        child: OptimizedCacheImage(
                            imageUrl:
                                'http://pngimg.com/uploads/google/google_PNG19635.png')),
                    label: Text(
                      "  Sign in with Google",
                      style: TextStyle(color: Colors.black),
                    )),
                ActionChip(
                  onPressed: () async {
                    await signInWithMicrosoft();
                    launchAUrl(
                        "https://visitcounter-fef16.firebaseapp.com/__/auth/handler");
                  },
                  label: Text(
                    'Microsoft Login',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.black,
                ),
              ],
            ),
          ),
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: InkWell(
          //     onTap: () async {
          //       launchAUrl("https://www.linkedin.com/in/kunal-jain-junior");
          //     },
          //     enableFeedback: true,
          //     child: Padding(
          //       padding: const EdgeInsets.only(bottom: 20.0),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           Text(
          //             "developed by   ",
          //             style: TextStyle(color: Colors.grey),
          //           ),
          //           // Text("Kunal jain RTU'23"),
          //           OptimizedCacheImage(
          //             imageUrl:
          //                 "https://media-exp1.licdn.com/dms/image/D4D35AQE0X3QpjRFf8A/profile-framedphoto-shrink_200_200/0/1666111396732?e=1670022000&v=beta&t=rnWfs-Iq7jkHffKCjYjci-MEZlj4HZXtOxIkm37d_yg",
          //             fit: BoxFit.contain,
          //             imageBuilder: (context, image) {
          //               return CircleAvatar(
          //                 radius: 15,
          //                 foregroundImage: image,
          //               );
          //             },
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
