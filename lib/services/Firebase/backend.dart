import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:samadhyan/Utilities/launch_a_url.dart';
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
      num rollNumber =
          int.tryParse(userEmail.substring(2, userEmail.length)) ?? 0;
      String branch = rollNumber == 0 ? userEmail : userEmail.substring(0, 2);

      // Update data to server if new user
      Timestamp t = Timestamp.now();
      bool isStudent = true;

      try {
        isStudent = useR.email!.contains(RegExp(r'[0-9]'));
      } catch (e) {
        isStudent = false;
      }
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
              "https://firebasestorage.googleapis.com/v0/b/visitcounter-fef16.appspot.com/o/ezgif.com-gif-maker%20(1).jpg?alt=media&token=f6a09471-bbd3-4298-a694-7ef920d9a5b0",
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
              'imageurl': useR.photoURL ?? "https://firebasestorage.googleapis.com/v0/b/visitcounter-fef16.appspot.com/o/ezgif.com-gif-maker%20(1).jpg?alt=media&token=f6a09471-bbd3-4298-a694-7ef920d9a5b0",
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
  launchAUrl("https://login.microsoftonline.com/common/oauth2/logout?");
  FirebaseAuth.instance.signOut();
  Fluttertoast.showToast(
      msg: "Now you can use another account", timeInSecForIosWeb: 1);
}

Future<UserCredential?> signInWithMicrosoft() async {
  final microsoftProvider = MicrosoftAuthProvider();
  // debugPrint(microsoftProvider.parameters.toString());
  // https://developers.google.com/identity/openid-connect/openid-connect#authenticationuriparameters
  microsoftProvider.setCustomParameters({
    'prompt': 'select_account',
    // 'login_hint': "cs19503@rtu.ac.in",
    "login_hint": "Example-cs19503@rtu.ac.in",
    // 'response_type': 'code',
    // 'response_mode': 'query',
    // 'scope': 'openid profile email',
    // 'display': 'popup', // page, popup, touch, and wap
    // 'locale': 'en-us',

    // "redirect_uri": "https://visitcounter-fef16.firebaseapp.com/__/auth/handler"
  });
  // Extra information eg. phone
  // microsoftProvider.addScope('openid');
  User user;
  late UserCredential _userCredential;
  try {
    if (kIsWeb) {
      var userCredential =
          await FirebaseAuth.instance.signInWithPopup(microsoftProvider);
      _userCredential = userCredential;
      user = userCredential.user!;
      devMode
          ? Fluttertoast.showToast(
              msg: userCredential.toString(), timeInSecForIosWeb: 10)
          : null;
    } else {
      var userCredential =
          await FirebaseAuth.instance.signInWithProvider(microsoftProvider);
      _userCredential = userCredential;
      user = userCredential.user!;
    }
    debugPrint(_userCredential.toString());
    if (user.email!.endsWith("@rtu.ac.in")) {
      userEmail = user.email!.split("@")[0];
//       UserCredential(additionalUserInfo: AdditionalUserInfo(isNewUser: false, profile: {businessPhones: [],
// preferredLanguage: null, mail: CS19503@rtu.ac.in, mobilePhone: 6378683117, officeLocation: null, displayName:
// KUNAL JAIN, surname: JAIN, givenName: KUNAL, jobTitle: Student, @odata.context:
// https://graph.microsoft.com/v1.0/$metadata#users/$entity, id: 805f716a-5213-4a66-aa87-d13619689cae,
// userPrincipalName: CS19503@rtu.ac.in}, providerId: microsoft.com, username: null), credential:
// AuthCredential(providerId: microsoft.com, signInMethod: microsoft.com, token: null, accessToken:
// eyJ0eXAiOiJKV1QiLCJub25jZSI6InByckxQT05zVm1FWnhjeHdEZnBBbVVjVkNrSVg4Sll1Rzg4YUN0bjZEcWciLCJhbGciOiJSUzI1NiIsIng1dCI6Ii1LSTNROW5OUjdiUm9meG1lWm9YcWJIWkdldyIsImtpZCI6Ii1LSTNROW5OUjdiUm9meG1lWm9YcWJIWkdldyJ9.eyJhdWQiOiIwMDAwMDAwMy0wMDAwLTAwMDAtYzAwMC0wMDAwMDAwMDAwMDAiLCJpc3MiOiJodHRwczovL3N0cy53aW5kb3dzLm5ldC85YTk5OTg0YS1kODEwLTQzZjEtYjk5Mi1kZDVmMDBkMmYzMzMvIiwiaWF0IjoxNjczMTkxNTc1LCJuYmYiOjE2NzMxOTE1NzUsImV4cCI6MTY3MzE5Njk3NywiYWNjdCI6MCwiYWNyIjoiMSIsImFpbyI6IkFUUUF5LzhUQUFBQXlSM0FPNHhJYk51NDJDbjZHbUpjbGd6S3RmL1VBeTZJK1ZZejFTazExZjBhN2JUVGNiSUh4d3hDZjRDcUlNVUwiLCJhbXIiOlsicHdkIl0sImFwcF9kaXNwbGF5bmFtZSI6IlN0dWRlbnQgQWN0aXZpdHkgQ2VudGVyIiwiYXBwaWQiOiIwYjMyYWRhOS0yNzM5LTRmZjctOTMxNi1iMGZhYmEyNmVhMjMiLCJhcHBpZGFjciI6IjEiLCJmYW1pbHlfbmFtZSI6IkpBSU4iLCJnaXZlbl9uYW1lIjoiS1VOQUwiLCJpZHR5cCI6InVzZXIiLCJpcGFkZHIiOiI0OS4zNi4yMzYuMTk3IiwibmFtZSI6IktVTkFMIEpBSU4iLCJvaWQiOiI4MDVmNzE2YS01MjEzLTRhNjYtYWE4Ny1kMTM2MTk2ODljYWUiLCJwbGF0ZiI6IjMiLCJwdWlkIjoiMTAwMzIwMDBEMTM3RkZFNyIsInJoIjoiMC5BVllBU3BpWm1oRFk4VU81a3QxZkFOTHpNd01BQUFBQUFBQUF3QUFBQUFBQUFBQldBTjAuIiwic2NwIjoiZW1haWwgb3BlbmlkIHByb2ZpbGUgVXNlci5SZWFkIiwic3ViIjoiSE9kRUJQYTBDRkpVUmtiOXVqZTktX19Md0tDdzVweWVjSV9pelEwdmpfdyIsInRlbmFudF9yZWdpb25fc2NvcGUiOiJBUyIsInRpZCI6IjlhOTk5ODRhLWQ4MTAtNDNmMS1iOTkyLWRkNWYwMGQyZjMzMyIsInVuaXF1ZV9uYW1lIjoiQ1MxOTUwM0BydHUuYWMuaW4iLCJ1cG4iOiJDUzE5NTAzQHJ0dS5hYy5pbiIsInV0aSI6ImRRNTlHYmItMDBhVXA4Q05fbUFrQVEiLCJ2ZXIiOiIxLjAiLCJ3aWRzIjpbImI3OWZiZjRkLTNlZjktNDY4OS04MTQzLTc2YjE5NGU4NTUwOSJdLCJ4bXNfc3QiOnsic3ViIjoiOGxpVTU0MWRPbmptQ2xuSGJXTFBGdzhCdXN2bEdRc3AzM28yT1lPV1B4WSJ9LCJ4bXNfdGNkdCI6MTQ4MDIyMjkyOX0.Px2kp0FFpQuh4ORsSvCLidVERMJx1xAS4dZjZ12FfUYlADngm1hNETU1zxhOrdJH2Ncpxp3hlQo1KsMbYf84vdhLJbcdxtYI8ALWC06hMjAG8ROsYlJPol9k4gZmoKejo-WNjp9ouIvMOLnXLfXx8vDYHfZjWnh8MObAldhEangUjtJTFf6A2Bpr0pAhOH8dngTDEJ6i4qbj0exAkShZMqbBQPc3tJZ54nOqcsFRee2CKUdJ3ZzlLKSABDuAtKZcs5UZ4bIBLSB8f0w3rtl5F45yqiKYobb8n17dRF2RkpmMq9j6UBKXfGWw8kKKGdharLbjqZPNLfSZWvdeAyxCTQ), user: User(displayName: KUNAL JAIN, email: cs19503@rtu.ac.in, emailVerified:
// false, isAnonymous: false, metadata: UserMetadata(creationTime: 2022-12-17 12:10:37.000Z, lastSignInTime:
// 2023-01-08 10:01:17.000Z), phoneNumber: null, photoURL: null, providerData, [UserInfo(displayName: KUNAL JAIN,
// email: cs19503@rtu.ac.in, phoneNumber: null, photoURL: null, providerId: microsoft.com, uid:
// 805f716a-5213-4a66-aa87-d13619689cae)], refreshToken:
// AOkPPWRPYisJKZCABPprxYKjNs-A0lN3V3v7GCEVVyr2evLd5eRyAiodvS3zkq_hr9GPN6k-IHHyv3Pw1nLZ6NaERFONmyMBVTO4tc6j5dUGLbGZ5zlT0yU2guDfRpib7VriypTwbydx6_IrNfnkzNY7Tdd6DcfrmaqC3KgOAUHVvZM5wF8QUyiKoVNEZL4No2ITOY1iFFUm_DIGYLhWTv
      userContactNumber =
          _userCredential.additionalUserInfo!.profile!['mobilePhone'];
      await AddUser(user).addUser();
      return _userCredential;
    } else {
      await signOut();
      Fluttertoast.showToast(
          msg: "Please use RTU email(example.rtu.ac.in) to login",
          timeInSecForIosWeb: 4);
    }
  } catch (e) {
    Fluttertoast.showToast(msg: e.toString(), timeInSecForIosWeb: 4);
  }
  return null;
}
