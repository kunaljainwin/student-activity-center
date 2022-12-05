import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:samadhyan/constants.dart';

import 'package:samadhyan/main.dart';

import '../Common Screens/login_page.dart';

late DocumentSnapshot userSnapshot;
Widget passwordLessSignIn(BuildContext context) {
  FirebaseAuth auth = FirebaseAuth.instance;

  return StreamBuilder(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        if (auth.currentUser == null) {
          return const LoginPage();
        } else if (auth.currentUser != null) {
          return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(auth.currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  userSnapshot = snapshot.data!;
                  isLoggedIn = true;
                  userEmail = userSnapshot["useremail"];
                  userName = userSnapshot["nickname"];
                  return const MyHomePage();
                }

                return Container(
                    color: Colors.white,
                    child: Center(child: CircularProgressIndicator()));
              });
        }
        return const LoginPage();
      });
}
