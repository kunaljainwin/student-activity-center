import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:samadhyan/constants.dart';

Future<User?> signInWithGoogle() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;

  if (kIsWeb) {
    try {
      GoogleAuthProvider authProvider = GoogleAuthProvider();
      final UserCredential userCredential =
          await auth.signInWithPopup(authProvider);

      user = userCredential.user;
      if (user != null) {
        await AddUser(user).addUser();
      }
    } catch (e) {}
  } else {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential userCredential =
          await auth.signInWithCredential(credential);

      user = userCredential.user;
      if (user != null) {
        await AddUser(user).addUser();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
  return user;
}

class AddUser {
  User useR;
  AddUser(this.useR);

  // Create a CollectionReference called users that references the firestore collection
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser() async {
    // userId = useR.uid;
    // Check is already sign up

    userEmail = useR.email!.split("@")[0];

    DocumentSnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .doc(userEmail)
        .get();
    if (result.exists == false) {
      num rollNumber = int.parse(userEmail.substring(2, userEmail.length));
      String branch = userEmail.substring(0, 2);

      // Update data to server if new user
      Timestamp t = Timestamp.now();
      bool isStudent = useR.email!.contains(RegExp(r'[0-9]'));
      await FirebaseFirestore.instance.collection('users').doc(userEmail).set(
        {
          'rank': isStudent ? 3 : 1,
          'branch': branch.toUpperCase(),
          'rollnumber': rollNumber,
          'useremail': useR.email ?? "",
          'nickname': useR.displayName ?? "",
          'phone': useR.phoneNumber ?? "",
          'home': userLocation,
          'registerations': 0,
          'attendance': 0,
          'imageurl': useR.photoURL ??
              "https://firebasestorage.googleapis.com/v0/b/visitcounter-fef16.appspot.com/o/files%2Frultimatrix%40gmail.com%2Fdata%2Fuser%2F0%2Fcom.example.visitcounter%2Fcache%2Ffile_picker%2FIMG-20221201-WA0014.jpg%2FTimeOfDay(23%3A34)?alt=media&token=ba377716-1f41-443a-9c93-182bdfefd733",
          'id': useR.uid,
          "dateofbirth": t,
          'firsttime': t,
          "lasttime": useR.metadata.lastSignInTime,
          "fcmtoken": userNewFCMToken,
          "gmail": ""
        },
      );
    } else {
      isLoggedIn = true;
      userFCMToken = result['fcmtoken'];
      return userFCMToken != userNewFCMToken
          ? FirebaseFirestore.instance.collection('users').doc(userEmail).set({
              "fcmtoken": userNewFCMToken,
              "lasttime": useR.metadata.lastSignInTime,
              'imageurl': useR.photoURL ?? "",
              'nickname': useR.displayName ?? "",
            }, SetOptions(merge: true))
          : null;
    }
  }
}

Future<void> signOut() async {
  try {
    GoogleSignIn().signOut();
    // await GoogleSignIn().disconnect();
  } catch (e) {
    debugPrint(e.toString());
  }
  FirebaseAuth.instance.signOut();
  Fluttertoast.showToast(
      msg: "Now you can use another account", timeInSecForIosWeb: 1);
}

Future<void> signInWithMicrosoft() async {
  final microsoftProvider = MicrosoftAuthProvider();
  // debugPrint(microsoftProvider.parameters.toString());
  microsoftProvider.setCustomParameters({
    'prompt': 'select_account',
    'login_hint': "cs19503@rtu.ac.in"
    // "domain_hint": "rtu.ac.in"
  });
  microsoftProvider.addScope('openid');
  User user;
  try {
    if (kIsWeb) {
      var userCredential =
          await FirebaseAuth.instance.signInWithPopup(microsoftProvider);
      user = userCredential.user!;
    } else {
      var userCredential =
          await FirebaseAuth.instance.signInWithProvider(microsoftProvider);
      user = userCredential.user!;
    }
    debugPrint(user.toString());
    if (user.email!.endsWith("@rtu.ac.in")) {
      userEmail = user.email!.split("@")[0];
      await AddUser(user).addUser();
    } else {
      await signOut();
      Fluttertoast.showToast(
          msg: "Please use RTU email to login", timeInSecForIosWeb: 4);
    }
  } catch (e) {
    debugPrint(e.toString());
    Fluttertoast.showToast(msg: e.toString(), timeInSecForIosWeb: 4);
  }
}
