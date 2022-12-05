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
    QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: useR.uid)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    if (documents.isEmpty) {
      // Update data to server if new user
      Timestamp t = Timestamp.now();
      await FirebaseFirestore.instance.collection('users').doc(useR.uid).set(
        {
          'rank': 3,
          'useremail': useR.email ?? "",
          'nickname': useR.displayName ?? "",
          'home': userLocation,
          'registerations': 0,
          'attendance': 0,
          'imageurl': useR.photoURL ?? "",
          'id': useR.uid,
          "dateofbirth": t,
          'firsttime': t,
          "lasttime": DateTime.now(),
          "fcmtoken": userNewFCMToken,
        },
      );
    } else {
      isLoggedIn = true;
      return userFCMToken != userNewFCMToken
          ? FirebaseFirestore.instance.collection('users').doc(useR.uid).set({
              "fcmtoken": userNewFCMToken,
              "lasttime": DateTime.now(),
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
  debugPrint(microsoftProvider.parameters.toString());
  microsoftProvider.setCustomParameters({
    'prompt': 'select_account',
    'login_hint': "Only for RTU Teachers and Students"
  });

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
