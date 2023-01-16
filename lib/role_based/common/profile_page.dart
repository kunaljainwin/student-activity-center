import 'package:flutter/material.dart';
import 'package:samadhyan/constants.dart';
import 'package:samadhyan/widgets/login_helpers.dart';
import 'package:samadhyan/widgets/title_box.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(8),
        children: [
          titleBox("Name"),
          Text(userName),
          titleBox("Email"),
          Text(userEmail),
          titleBox("Branch"),
          Text(userSnapshot['branch']),
          titleBox("Roll Number"),
          Text(userSnapshot['rollnumber'].toString()),
          // SizedBox(
          //   width: 155.52,
          //   height: 244.08,
          //   child: Material(
          //     color: Colors.white,
          //     child: Stack(
          //       children: [
          //         Positioned.fill(
          //           child: Align(
          //             alignment: Alignment.bottomLeft,
          //             child: SizedBox(
          //               width: 155,
          //               height: 190,
          //               child: Material(
          //                 color: Color(0xffc34342),
          //                 child: Stack(
          //                   children: [
          //                     Positioned(
          //                       left: 45.70,
          //                       top: 87.56,
          //                       child: Text(
          //                         "News Reporter",
          //                         textAlign: TextAlign.center,
          //                         style: TextStyle(
          //                           color: Colors.white,
          //                           fontSize: 7.43,
          //                           fontFamily: "Inter",
          //                           fontWeight: FontWeight.w500,
          //                           letterSpacing: 0.89,
          //                         ),
          //                       ),
          //                     ),
          //                     Positioned(
          //                       left: 48.22,
          //                       top: 8.73,
          //                       child: SizedBox(
          //                         width: 58.70,
          //                         height: 58.70,
          //                         child: Material(
          //                           color: Color(0xffe9e7e8),
          //                         ),
          //                       ),
          //                     ),
          //                     Positioned(
          //                       left: 51.57,
          //                       top: 11.67,
          //                       child: SizedBox(
          //                         width: 52.41,
          //                         height: 52.41,
          //                         child: Material(
          //                           color: Color(0x33ff8585),
          //                         ),
          //                       ),
          //                     ),
          //                     Positioned(
          //                       left: 53.41,
          //                       top: 74.98,
          //                       child: Text(
          //                         "John Doe",
          //                         textAlign: TextAlign.center,
          //                         style: TextStyle(
          //                           color: Colors.white,
          //                           fontSize: 10.48,
          //                           fontFamily: "Inter",
          //                           fontWeight: FontWeight.w700,
          //                         ),
          //                       ),
          //                     ),
          //                     Positioned(
          //                       left: 23.06,
          //                       top: 106.01,
          //                       child: SizedBox(
          //                         width: 109.02,
          //                         height: 47.80,
          //                         child: Material(
          //                           color: Color(0xffb03a3a),
          //                           borderRadius: BorderRadius.circular(6.29),
          //                         ),
          //                       ),
          //                     ),
          //                     Positioned(
          //                       left: 31.45,
          //                       top: 114.82,
          //                       child: Text(
          //                         "ID NO",
          //                         style: TextStyle(
          //                           color: Colors.white,
          //                           fontSize: 7.43,
          //                         ),
          //                       ),
          //                     ),
          //                     Positioned(
          //                       left: 31.45,
          //                       top: 125.30,
          //                       child: Text(
          //                         "BLOOD",
          //                         style: TextStyle(
          //                           color: Colors.white,
          //                           fontSize: 7.43,
          //                         ),
          //                       ),
          //                     ),
          //                     Positioned(
          //                       left: 31.45,
          //                       top: 135.78,
          //                       child: Text(
          //                         "MOBILE",
          //                         style: TextStyle(
          //                           color: Colors.white,
          //                           fontSize: 7.43,
          //                         ),
          //                       ),
          //                     ),
          //                     Positioned(
          //                       left: 64.15,
          //                       top: 114.82,
          //                       child: Text(
          //                         ":",
          //                         style: TextStyle(
          //                           color: Colors.white,
          //                           fontSize: 7.43,
          //                         ),
          //                       ),
          //                     ),
          //                     Positioned(
          //                       left: 64.15,
          //                       top: 125.30,
          //                       child: Text(
          //                         ":",
          //                         style: TextStyle(
          //                           color: Colors.white,
          //                           fontSize: 7.43,
          //                         ),
          //                       ),
          //                     ),
          //                     Positioned(
          //                       left: 64.15,
          //                       top: 135.78,
          //                       child: Text(
          //                         ":",
          //                         style: TextStyle(
          //                           color: Colors.white,
          //                           fontSize: 7.43,
          //                         ),
          //                       ),
          //                     ),
          //                     Positioned(
          //                       left: 71.28,
          //                       top: 114.82,
          //                       child: Text(
          //                         "0005621",
          //                         style: TextStyle(
          //                           color: Color(0xe5e9e7e8),
          //                           fontSize: 7.43,
          //                           fontFamily: "Inter",
          //                           fontWeight: FontWeight.w300,
          //                         ),
          //                       ),
          //                     ),
          //                     Positioned(
          //                       left: 71.28,
          //                       top: 125.30,
          //                       child: Text(
          //                         "B+ (ve)",
          //                         style: TextStyle(
          //                           color: Color(0xe5e9e7e8),
          //                           fontSize: 7.43,
          //                           fontFamily: "Inter",
          //                           fontWeight: FontWeight.w300,
          //                         ),
          //                       ),
          //                     ),
          //                     Positioned(
          //                       left: 71.28,
          //                       top: 135.78,
          //                       child: Text(
          //                         "0133005100",
          //                         style: TextStyle(
          //                           color: Color(0xe5e9e7e8),
          //                           fontSize: 7.43,
          //                           fontFamily: "Inter",
          //                           fontWeight: FontWeight.w300,
          //                         ),
          //                       ),
          //                     ),
          //                     Positioned(
          //                       left: 51.57,
          //                       top: 11.67,
          //                       child: SizedBox(
          //                         width: 52.41,
          //                         height: 52.41,
          //                         child: Material(
          //                           color: Color(0x33ff8585),
          //                         ),
          //                       ),
          //                     ),
          //                     Positioned(
          //                       left: 29.20,
          //                       top: 164.71,
          //                       child: Text(
          //                         "www.website24.com",
          //                         textAlign: TextAlign.center,
          //                         style: TextStyle(
          //                           color: Colors.white,
          //                           fontSize: 7.43,
          //                           fontFamily: "Inter",
          //                           fontWeight: FontWeight.w900,
          //                           letterSpacing: 0.89,
          //                         ),
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //         Positioned(
          //           left: -21.38,
          //           top: 53.93,
          //           child: Container(
          //             width: 191.62,
          //             height: 107.76,
          //             child: FlutterLogo(size: 107.7588119506836),
          //           ),
          //         ),
          //         Positioned(
          //           left: 30.19,
          //           top: 13.26,
          //           child: Text(
          //             "PRESS",
          //             textAlign: TextAlign.center,
          //             style: TextStyle(
          //               color: Color(0xffc34342),
          //               fontSize: 27.25,
          //               fontFamily: "Inter",
          //               fontWeight: FontWeight.w800,
          //             ),
          //           ),
          //         ),
          //         Positioned(
          //           left: 31.03,
          //           top: 41.77,
          //           child: Text(
          //             "REPORTER ID CARD",
          //             textAlign: TextAlign.center,
          //             style: TextStyle(
          //               color: Color(0xffc34342),
          //               fontSize: 7.43,
          //               fontFamily: "Inter",
          //               fontWeight: FontWeight.w500,
          //               letterSpacing: 0.89,
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          // SizedBox(
          //   width: 155.52,
          //   height: 244.08,
          //   child: Material(
          //     color: Colors.white,
          //     child: Stack(
          //       children: [
          //         Positioned.fill(
          //           child: Align(
          //             alignment: Alignment.center,
          //             child: SizedBox(
          //               width: 155,
          //               height: 107.76,
          //               child: Material(
          //                 color: Color(0xe5ffffff),
          //                 child: Padding(
          //                   padding: const EdgeInsets.only(
          //                     left: 41,
          //                     right: 42,
          //                     top: 4,
          //                     bottom: 16,
          //                   ),
          //                   child: Column(
          //                     mainAxisSize: MainAxisSize.min,
          //                     mainAxisAlignment: MainAxisAlignment.end,
          //                     crossAxisAlignment: CrossAxisAlignment.center,
          //                     children: [
          //                       Container(
          //                         width: 49.90,
          //                         height: 49.90,
          //                         child: FlutterLogo(size: 49.89610290527344),
          //                       ),
          //                       SizedBox(height: 6.80),
          //                       Text(
          //                         "www.website24.com",
          //                         textAlign: TextAlign.center,
          //                         style: TextStyle(
          //                           color: Color(0xffb03a3a),
          //                           fontSize: 5.65,
          //                           fontFamily: "Inter",
          //                           fontWeight: FontWeight.w900,
          //                           letterSpacing: 0.68,
          //                         ),
          //                       ),
          //                       SizedBox(height: 6.80),
          //                       Text(
          //                         "+01 151515 522521\neditor@website24.com\nNew York, US",
          //                         textAlign: TextAlign.center,
          //                         style: TextStyle(
          //                           color: Color(0xffc34342),
          //                           fontSize: 4.79,
          //                           fontFamily: "Inter",
          //                           fontWeight: FontWeight.w300,
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //         Positioned(
          //           left: 48.22,
          //           top: 70.15,
          //           child: SizedBox(
          //             width: 58.70,
          //             height: 58.70,
          //             child: Material(
          //               color: Color(0xffe9e7e8),
          //             ),
          //           ),
          //         ),
          //         Positioned.fill(
          //           child: Align(
          //             alignment: Alignment.topLeft,
          //             child: SizedBox(
          //               width: 155,
          //               height: 54,
          //               child: Material(
          //                 color: Color(0xffc34342),
          //                 child: Stack(
          //                   children: [
          //                     Positioned.fill(
          //                       child: Align(
          //                         alignment: Alignment.center,
          //                         child: Text(
          //                           "PRESS",
          //                           textAlign: TextAlign.center,
          //                           style: TextStyle(
          //                             color: Colors.white,
          //                             fontSize: 27.25,
          //                             fontFamily: "Inter",
          //                             fontWeight: FontWeight.w800,
          //                           ),
          //                         ),
          //                       ),
          //                     ),
          //                     Positioned(
          //                       left: 30.27,
          //                       top: 41.77,
          //                       child: Text(
          //                         "REPORTER ID CARD",
          //                         textAlign: TextAlign.center,
          //                         style: TextStyle(
          //                           color: Colors.white,
          //                           fontSize: 7.43,
          //                           fontFamily: "Inter",
          //                           fontWeight: FontWeight.w500,
          //                           letterSpacing: 0.89,
          //                         ),
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //         Positioned.fill(
          //           child: Align(
          //             alignment: Alignment.bottomLeft,
          //             child: SizedBox(
          //               width: 157,
          //               height: 50,
          //               child: Material(
          //                 color: Color(0xffc34342),
          //                 child: Padding(
          //                   padding: const EdgeInsets.only(
          //                     left: 31,
          //                     right: 32,
          //                     top: 2,
          //                     bottom: 15,
          //                   ),
          //                   child: Column(
          //                     mainAxisSize: MainAxisSize.min,
          //                     mainAxisAlignment: MainAxisAlignment.start,
          //                     crossAxisAlignment: CrossAxisAlignment.start,
          //                     children: [
          //                       Text(
          //                         "Expiry",
          //                         style: TextStyle(
          //                           color: Colors.white,
          //                           fontSize: 7.43,
          //                         ),
          //                       ),
          //                       SizedBox(height: 0.08),
          //                       Text(
          //                         ":",
          //                         style: TextStyle(
          //                           color: Colors.white,
          //                           fontSize: 7.43,
          //                         ),
          //                       ),
          //                       SizedBox(height: 0.08),
          //                       Text(
          //                         "31 OCT 2023",
          //                         style: TextStyle(
          //                           color: Color(0xe5e9e7e8),
          //                           fontSize: 7.43,
          //                           fontFamily: "Inter",
          //                           fontWeight: FontWeight.w300,
          //                         ),
          //                       ),
          //                       SizedBox(height: 0.08),
          //                       Text(
          //                         "All rights reserved © 2022 website24.com",
          //                         textAlign: TextAlign.center,
          //                         style: TextStyle(
          //                           color: Colors.white,
          //                           fontSize: 4.79,
          //                           fontFamily: "Inter",
          //                           fontWeight: FontWeight.w200,
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //         Positioned(
          //           left: 23.06,
          //           top: 171.33,
          //           child: SizedBox(
          //             width: 109.02,
          //             height: 36.48,
          //             child: Material(
          //               color: Color(0xffb03a3a),
          //               borderRadius: BorderRadius.circular(6.29),
          //               child: Padding(
          //                 padding: const EdgeInsets.only(
          //                   left: 8,
          //                   right: 14,
          //                   top: 9,
          //                   bottom: 19,
          //                 ),
          //                 child: Row(
          //                   mainAxisSize: MainAxisSize.min,
          //                   mainAxisAlignment: MainAxisAlignment.start,
          //                   crossAxisAlignment: CrossAxisAlignment.start,
          //                   children: [
          //                     Text(
          //                       "Start",
          //                       style: TextStyle(
          //                         color: Colors.white,
          //                         fontSize: 7.43,
          //                       ),
          //                     ),
          //                     SizedBox(width: 9.42),
          //                     Text(
          //                       ":",
          //                       style: TextStyle(
          //                         color: Colors.white,
          //                         fontSize: 7.43,
          //                       ),
          //                     ),
          //                     SizedBox(width: 9.42),
          //                     Text(
          //                       "01 NOV 2022",
          //                       style: TextStyle(
          //                         color: Color(0xe5e9e7e8),
          //                         fontSize: 7.43,
          //                         fontFamily: "Inter",
          //                         fontWeight: FontWeight.w300,
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          // SizedBox(
          //   width: 155.52,
          //   height: 244.08,
          //   child: Material(
          //     color: Colors.white,
          //     child: Stack(
          //       children: [
          //         Positioned.fill(
          //           child: Align(
          //             alignment: Alignment.center,
          //             child: SizedBox(
          //               width: 155,
          //               height: 107.76,
          //               child: Material(
          //                 color: Color(0xe5ffffff),
          //                 child: Padding(
          //                   padding: const EdgeInsets.only(
          //                     left: 41,
          //                     right: 42,
          //                     top: 4,
          //                     bottom: 16,
          //                   ),
          //                   child: Column(
          //                     mainAxisSize: MainAxisSize.min,
          //                     mainAxisAlignment: MainAxisAlignment.end,
          //                     crossAxisAlignment: CrossAxisAlignment.center,
          //                     children: [
          //                       Container(
          //                         width: 49.90,
          //                         height: 49.90,
          //                         child: FlutterLogo(size: 49.89610290527344),
          //                       ),
          //                       SizedBox(height: 6.80),
          //                       Text(
          //                         "www.website24.com",
          //                         textAlign: TextAlign.center,
          //                         style: TextStyle(
          //                           color: Color(0xffb03a3a),
          //                           fontSize: 5.65,
          //                           fontFamily: "Inter",
          //                           fontWeight: FontWeight.w900,
          //                           letterSpacing: 0.68,
          //                         ),
          //                       ),
          //                       SizedBox(height: 6.80),
          //                       Text(
          //                         "+01 151515 522521\neditor@website24.com\nNew York, US",
          //                         textAlign: TextAlign.center,
          //                         style: TextStyle(
          //                           color: Color(0xffc34342),
          //                           fontSize: 4.79,
          //                           fontFamily: "Inter",
          //                           fontWeight: FontWeight.w300,
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //         Positioned(
          //           left: 48.22,
          //           top: 70.15,
          //           child: SizedBox(
          //             width: 58.70,
          //             height: 58.70,
          //             child: Material(
          //               color: Color(0xffe9e7e8),
          //             ),
          //           ),
          //         ),
          //         Positioned.fill(
          //           child: Align(
          //             alignment: Alignment.topLeft,
          //             child: SizedBox(
          //               width: 155,
          //               height: 54,
          //               child: Material(
          //                 color: Color(0xffc34342),
          //                 child: Stack(
          //                   children: [
          //                     Positioned.fill(
          //                       child: Align(
          //                         alignment: Alignment.center,
          //                         child: Text(
          //                           "PRESS",
          //                           textAlign: TextAlign.center,
          //                           style: TextStyle(
          //                             color: Colors.white,
          //                             fontSize: 27.25,
          //                             fontFamily: "Inter",
          //                             fontWeight: FontWeight.w800,
          //                           ),
          //                         ),
          //                       ),
          //                     ),
          //                     Positioned(
          //                       left: 30.27,
          //                       top: 41.77,
          //                       child: Text(
          //                         "REPORTER ID CARD",
          //                         textAlign: TextAlign.center,
          //                         style: TextStyle(
          //                           color: Colors.white,
          //                           fontSize: 7.43,
          //                           fontFamily: "Inter",
          //                           fontWeight: FontWeight.w500,
          //                           letterSpacing: 0.89,
          //                         ),
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //         Positioned.fill(
          //           child: Align(
          //             alignment: Alignment.bottomLeft,
          //             child: SizedBox(
          //               width: 157,
          //               height: 50,
          //               child: Material(
          //                 color: Color(0xffc34342),
          //                 child: Padding(
          //                   padding: const EdgeInsets.only(
          //                     left: 31,
          //                     right: 32,
          //                     top: 2,
          //                     bottom: 15,
          //                   ),
          //                   child: Column(
          //                     mainAxisSize: MainAxisSize.min,
          //                     mainAxisAlignment: MainAxisAlignment.start,
          //                     crossAxisAlignment: CrossAxisAlignment.start,
          //                     children: [
          //                       Text(
          //                         "Expiry",
          //                         style: TextStyle(
          //                           color: Colors.white,
          //                           fontSize: 7.43,
          //                         ),
          //                       ),
          //                       SizedBox(height: 0.08),
          //                       Text(
          //                         ":",
          //                         style: TextStyle(
          //                           color: Colors.white,
          //                           fontSize: 7.43,
          //                         ),
          //                       ),
          //                       SizedBox(height: 0.08),
          //                       Text(
          //                         "31 OCT 2023",
          //                         style: TextStyle(
          //                           color: Color(0xe5e9e7e8),
          //                           fontSize: 7.43,
          //                           fontFamily: "Inter",
          //                           fontWeight: FontWeight.w300,
          //                         ),
          //                       ),
          //                       SizedBox(height: 0.08),
          //                       Text(
          //                         "All rights reserved © 2022 website24.com",
          //                         textAlign: TextAlign.center,
          //                         style: TextStyle(
          //                           color: Colors.white,
          //                           fontSize: 4.79,
          //                           fontFamily: "Inter",
          //                           fontWeight: FontWeight.w200,
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //         Positioned(
          //           left: 23.06,
          //           top: 171.33,
          //           child: SizedBox(
          //             width: 109.02,
          //             height: 36.48,
          //             child: Material(
          //               color: Color(0xffb03a3a),
          //               borderRadius: BorderRadius.circular(6.29),
          //               child: Padding(
          //                 padding: const EdgeInsets.only(
          //                   left: 8,
          //                   right: 14,
          //                   top: 9,
          //                   bottom: 19,
          //                 ),
          //                 child: Row(
          //                   mainAxisSize: MainAxisSize.min,
          //                   mainAxisAlignment: MainAxisAlignment.start,
          //                   crossAxisAlignment: CrossAxisAlignment.start,
          //                   children: [
          //                     Text(
          //                       "Start",
          //                       style: TextStyle(
          //                         color: Colors.white,
          //                         fontSize: 7.43,
          //                       ),
          //                     ),
          //                     SizedBox(width: 9.42),
          //                     Text(
          //                       ":",
          //                       style: TextStyle(
          //                         color: Colors.white,
          //                         fontSize: 7.43,
          //                       ),
          //                     ),
          //                     SizedBox(width: 9.42),
          //                     Text(
          //                       "01 NOV 2022",
          //                       style: TextStyle(
          //                         color: Color(0xe5e9e7e8),
          //                         fontSize: 7.43,
          //                         fontFamily: "Inter",
          //                         fontWeight: FontWeight.w300,
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
