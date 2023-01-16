import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import 'package:samadhyan/Services/QR/mobile_scanner.dart';
import 'package:samadhyan/role_based/event_coordinator/excel.dart';
import 'package:samadhyan/services/firebase/dynamic_links_util.dart';
import 'package:samadhyan/widgets/title_box.dart';
import 'package:share_plus/share_plus.dart';

class EventDetails extends StatelessWidget {
  const EventDetails({super.key, required this.event});
  final DocumentSnapshot event;

  @override
  Widget build(BuildContext context) {
    num totalAttendees = event["attendees"].length;
    num totalRegistered = event["registered"].length + totalAttendees;
    // final notes = List<Widget>.generate(event['note'].length,
    //         (i) => Text((i + 1).toString() + ").  " + event['note'][i] + "."))
    //     .toList();
    return Scaffold(
      persistentFooterAlignment: AlignmentDirectional.center,
      persistentFooterButtons: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.arrow_back_ios)),
            IconButton(
              onPressed: () async {
                String eventUrl = await DynamicLinks.buildDynamicLink(
                    documentSnapshot: event);
                Share.share(
                    "Hey, I am inviting you to join this event. Please join this event by clicking on the link below. \n\n$eventUrl",
                    subject: "Join this event",
                    sharePositionOrigin: Rect.fromLTWH(0, 0, 0, 0));
              },
              icon: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(math.pi),
                  child: const Icon(
                    Icons.reply_outlined,
                    size: 30,
                  )),
            ),
          ],
        )
      ],
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      body: ListView(
        padding: EdgeInsets.all(8),
        children: [
          getAppBarUI(context),
          ElevatedButton(
              onPressed: () async {
                List<String> emails =
                    List<String>.from(event["registered"], growable: true);

                ExcelData.onSave(
                    eventName: event["title"],
                    fileName: "registerations",
                    names: emails);
              },
              child: const Text("Get excel of registered")),
          ElevatedButton(
              onPressed: () async {
                List<String> emails =
                    List<String>.from(event["attendees"], growable: true);
                ExcelData.onSave(
                    eventName: event["title"],
                    fileName: "attendance",
                    names: emails);
              },
              child: const Text("Get excel for attendees")),
          titleBox(
            "Registered :  " + totalRegistered.toString(),
          ),
          Wrap(
              children: event["registered"]
                  .map<Widget>((e) => ListTile(
                        title: Text(e),
                      ))
                  .toList()),
          titleBox("Attendees :  " + totalAttendees.toString()),
          Wrap(
              children: event["attendees"]
                  .map<Widget>((e) => ListTile(
                        title: Text(e),
                      ))
                  .toList())
        ],
      ),
    );
  }

  Widget getAppBarUI(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: const Offset(0, 2),
              blurRadius: 8.0),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, left: 8, right: 8),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Center(
                child: Text(
                  'Explore',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            Container(
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.edit),
                      ),
                    ),
                  ),
                  // Scanner and ""

                  IconButton(
                      onPressed: () => Get.to(() => Scanner(
                            documentSnapshot: event,
                          )),
                      icon: Icon(Icons.qr_code_scanner))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
