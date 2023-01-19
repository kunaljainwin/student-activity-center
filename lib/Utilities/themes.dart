import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final themeData = ThemeData(
  fontFamily: GoogleFonts.roboto().fontFamily,
  // primaryColor: Colors.white,
  useMaterial3: true,
  textTheme: GoogleFonts.robotoTextTheme(),
  primaryTextTheme: GoogleFonts.openSansTextTheme(),
  textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
          textStyle: TextStyle(fontFamily: GoogleFonts.lato().fontFamily))),
  // dialogTheme: DialogTheme(
  //     alignment: const Alignment(0, -0.5),
  //     shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(10))),
  // outlinedButtonTheme: OutlinedButtonThemeData(
  //     style: OutlinedButton.styleFrom(s
  //         textStyle: const TextStyle(color: Colors.black))),
);
