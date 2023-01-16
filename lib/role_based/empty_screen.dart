import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:samadhyan/utilities/send_email.dart';
import 'package:sizer/sizer.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.construction_rounded,
            size: 80.sp,
            // color: Colors.grey,
          ),
          TextButton(
              onPressed: () async {
                sendEmail("rultimatrix@gmail.com");
              },
              child: Text(
                "Report this issue or give suggestions",
                textScaleFactor: 1.2,
              ))
        ],
      )),
    ));
  }
}
