import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:samadhyan/constants.dart';
import 'package:samadhyan/role_based/common/home.dart';
import 'package:samadhyan/role_based/common/login_page.dart';

late DocumentSnapshot userSnapshot;
Widget passwordLessSignIn(BuildContext context) {
  FirebaseAuth auth = FirebaseAuth.instance;

  return StreamBuilder(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (auth.currentUser == null) {
            return const LoginPage();
          } else {
            userEmail = auth.currentUser!.email!.split("@")[0];
            return StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(userEmail)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.exists) {
                    userSnapshot = snapshot.data!;
                    isLoggedIn = true;
                    userName = userSnapshot["nickname"];
                    return const MyHomePage();
                  }
                  return const LoginPage();
                });
          }
        }
        return const Center(child: CircularProgressIndicator());
      });
}
