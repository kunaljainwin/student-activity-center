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
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            isLoggedIn
                ? const CircularProgressIndicator()
                : GoogleSignInButton(),
            SizedBox(
              width: 5.w,
            ),
            isLoggedIn
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, top: 4, bottom: 4),
                          child: Image(
                            image: AssetImage("lib/assets/microsoft_logo.png"),
                            height: 30.0,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          'Sign in with Microsoft',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      signInWithMicrosoft();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                    ),
                  )
          ],
        )
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
