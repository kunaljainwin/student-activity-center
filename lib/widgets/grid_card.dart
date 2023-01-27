import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class GridCard extends StatelessWidget {
  const GridCard({super.key, required this.e});
  final Map<String, Object> e;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(e["route"]);
      },
      child: Card(
          margin: EdgeInsets.all(1),
          child: Stack(
            children: [
              Center(
                child: SizedBox(
                  height: 12.h,
                  child: SvgPicture.asset(
                    e["svg_icon"].toString(),
                    key: Key(
                      e["svg_icon"].toString(),
                    ),
                    height: 80,
                  ),
                ),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 2.h),
                    child: Text(
                      e["title"].toString(),
                      style: TextStyle(
                          fontFamily: GoogleFonts.montserrat().fontFamily,
                          fontWeight: FontWeight.bold),
                    ),
                  ))
            ],
          )),
    );
  }
}
