import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:samadhyan/Utilities/launch_a_url.dart';
import 'package:samadhyan/constants.dart';

Future<User?> signInWithGoogle() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  UserCredential? userCredential = null;

  if (kIsWeb) {
    try {
      GoogleAuthProvider authProvider = GoogleAuthProvider();
      userCredential = await auth.signInWithPopup(authProvider);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
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

      userCredential = await auth.signInWithCredential(credential);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
  if (userCredential != null &&
      userCredential.user!.email!.endsWith("@rtu.ac.in")) {
    await AddUser(userCredential).addUser();
  } else {
    signOut();
    Fluttertoast.showToast(
        msg: "Please use RTU email(example.rtu.ac.in) to login",
        timeInSecForIosWeb: 4);
  }

  return userCredential!.user;
}

class AddUser {
  UserCredential userCredential;
  AddUser(this.userCredential);
  String provider = "google";
  // Create a CollectionReference called users that references the firestore collection
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser() async {
    final User user = userCredential.user!;
    if (user.email!.contains(".")) {
      provider = 'google';
    } else {
      provider = 'microsoft';
    }
    devMode ? debugPrint(userCredential.toString()) : null;
    userId = user.uid;
    userEmail = user.email!;
    userName = user.displayName!;
    // Check is already sign up
    DocumentSnapshot result =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (!result.exists) {
// google and microsoft accounts coming
      Timestamp t = Timestamp.now();

      // student or teacher
      bool isStudent = true;
      try {
        isStudent = user.email!.contains(RegExp(r'[0-9]'));
      } catch (e) {
        isStudent = false;
      }
      String userBranch = "";
      num userAdmissionYear = 0;
      num userRollNumber = 0;
      // conditional data transformation
      // This should be updated to get the right data from the user 🔥
      if (isStudent && provider == 'google') {
        //Eg. name.year branch rollnumber
        //nikhil.21it447
        String removeName = userEmail.split(".")[1];
        String removeDomain = removeName.split("@")[0];
        int n = removeDomain.length;

        userRollNumber = int.parse(removeDomain.substring(n - 3, n));
        userAdmissionYear = int.parse(removeDomain.substring(0, 2));
        userBranch = removeDomain.substring(2, n - 3);
      } else if (isStudent && provider == 'microsoft') {
        //Eg. branch year rollnumber
        //cs19503@rtu.ac.in
        String removeDomain = userEmail.split("@")[0];
        int n = removeDomain.length;

        userRollNumber = int.parse(removeDomain.substring(n - 3, n));
        userAdmissionYear = int.parse(removeDomain.substring(n - 5, n - 3));
        userBranch = removeDomain.substring(0, n - 5);
      }
      debugPrint("userEmail: $userEmail");
      debugPrint("userName: $userName");
      debugPrint("userBranch: $userBranch");
      debugPrint("userAdmissionYear: $userAdmissionYear");
      debugPrint("userRollNumber: $userRollNumber");

      await FirebaseFirestore.instance.collection('users').doc(userId).set(
        {
          'rank': isStudent ? 3 : 1,
          'branch': userBranch.toUpperCase(),
          'rollnumber': userRollNumber,
          'admissionyear': userAdmissionYear,
          'useremail': userCredential.user!.email ?? "",
          'nickname': user.displayName ?? "",
          'phone':
              userCredential.additionalUserInfo!.profile!['mobilePhone'] ?? '',
          'home': userLocation,
          'registerations': 0,
          'attendance': 0,
          'imageurl': user.photoURL ??
              "https://firebasestorage.googleapis.com/v0/b/visitcounter-fef16.appspot.com/o/ezgif.com-gif-maker%20(1).jpg?alt=media&token=f6a09471-bbd3-4298-a694-7ef920d9a5b0",
          'id': userId,
          "dateofbirth": t,
          'firsttime': t,
          "lasttime": user.metadata.lastSignInTime,
          "fcmtoken": userNewFCMToken,
          "secondemail": ""
        },
      );
    } else {
      isLoggedIn = true;
      userFCMToken = result['fcmtoken'];
      return userFCMToken != userNewFCMToken
          ? result.reference.set({
              "fcmtoken": userNewFCMToken,
              "lasttime": user.metadata.lastSignInTime,
              'imageurl': user.photoURL ??
                  "https://firebasestorage.googleapis.com/v0/b/visitcounter-fef16.appspot.com/o/ezgif.com-gif-maker%20(1).jpg?alt=media&token=f6a09471-bbd3-4298-a694-7ef920d9a5b0",
              'nickname': user.displayName ?? "",
            }, SetOptions(merge: true))
          : null;
    }
  }
}

Future<void> signOut() async {
  isLoggedIn = false;
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
  UserCredential? userCredential;
  try {
    if (kIsWeb) {
      userCredential =
          await FirebaseAuth.instance.signInWithPopup(microsoftProvider);
      userCredential = userCredential;
      user = userCredential.user!;
      devMode
          ? Fluttertoast.showToast(
              msg: userCredential.toString(), timeInSecForIosWeb: 10)
          : null;
    } else {
      userCredential =
          await FirebaseAuth.instance.signInWithProvider(microsoftProvider);
      userCredential = userCredential;
      user = userCredential.user!;
    }
    if (user.email!.endsWith("@rtu.ac.in")) {
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

      await AddUser(userCredential).addUser();
      return userCredential;
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
