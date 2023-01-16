import 'package:flutter/material.dart';

import 'package:samadhyan/constants.dart';
import 'package:samadhyan/Services/Firebase/backend.dart';

import 'package:samadhyan/widgets/google_signin_button.dart';
import 'package:sizer/sizer.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterAlignment: AlignmentDirectional.topCenter,
      persistentFooterButtons: [
        devMode ? GoogleSignInButton() : SizedBox.shrink(),
        isLoggedIn
            ? CircularProgressIndicator()
            : ActionChip(
                onPressed: () {
                  signInWithMicrosoft();
                },
                label: const Text(
                  'Sign in with Microsoft',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.black,
              ),
      ],
      body: Center(
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
            const Text(
              appName,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
