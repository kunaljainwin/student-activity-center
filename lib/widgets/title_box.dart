import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

Widget titleBox(String title) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 4.w),
    child: Wrap(
      children: [
        const SizedBox(height: 24),
        Chip(
          labelPadding: EdgeInsets.all(4),
          label: Text(title,
              // textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.nunito().fontFamily,
              )),
        ),
        const SizedBox(height: 8),
      ],
    ),
  );
}
