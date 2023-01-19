import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

import 'package:samadhyan/constants.dart';
import 'package:samadhyan/services/Firebase/dynamic_links_util.dart';
import 'package:samadhyan/widgets/login_helpers.dart';

import 'package:samadhyan/widgets/view_image.dart';
import 'dart:math' as math;

import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

class EventDetails extends StatelessWidget {
  const EventDetails({super.key, required this.event});
  final DocumentSnapshot event;
  @override
  Widget build(BuildContext context) {
    bool isRegistered =
        List<String>.from(event["registered"]).contains(userEmail);

    bool isAttended = List<String>.from(event["attendees"]).contains(userEmail);

    int endTime = event['startTime'].millisecondsSinceEpoch;

    // final notes = List<Widget>.generate(event['note'].length,
    //         (i) => Text((i + 1).toString() + ").  " + event['note'][i] + "."))
    // .toList();
    var textStyleTitle = TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
    return Scaffold(
      persistentFooterAlignment: AlignmentDirectional.center,
      persistentFooterButtons: [
        IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios)),
        ActionChip(
          backgroundColor: isRegistered ? Colors.grey : Colors.blue,
          onPressed: isRegistered
              ? null
              : () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return dialogForRegisterNow(context);
                      });
                },
          tooltip: "Register Now",
          label: isRegistered
              ? CountdownTimer(
                  endTime: endTime,
                )
              : const Text(
                  "Register Now",
                  textScaleFactor: 1.3,
                  style: TextStyle(color: Colors.white),
                ),
        ),
        IconButton(
          onPressed: () async {
            String eventUrl =
                await DynamicLinks.buildDynamicLink(documentSnapshot: event);
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
      // extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //   // leadingWidth: 20,
      //   title: Text(
      //     event['title'],
      //     style: TextStyle(color: Colors.black),
      //   ),
      //   // toolbarHeight: 30,
      //   // toolbarOpacity: 0,
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back_ios),
      //     onPressed: () => Get.back(),
      //   ),
      //   automaticallyImplyLeading: false,
      //   toolbarHeight: 40,
      //   // backgroundColor: Colors.transparent,
      // ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          InkWell(
            onTap: () {
              Get.to(() => PhotoViewer(imagePath: event['eventPosterLink']));
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              height: 50.h,
              child: OptimizedCacheImage(
                imageUrl: event['eventPosterLink'],
                imageRenderMethodForWeb: ImageRenderMethodForWeb.HttpGet,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
            ),
          ),

          Container(
            height: 50,
            padding: EdgeInsets.only(top: 10, left: 10),
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: [
                Text(
                  event['title'],
                  style: textStyleTitle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  width: 20,
                ),
                IconButton(
                  onPressed: () {
                    Event e = Event(
                      title: event['title'],
                      description: event['description'],
                      location: event['location'].toString(),
                      startDate: event["startTime"].toDate(),
                      endDate: event["endTime"].toDate(),
                    );

                    Add2Calendar.addEvent2Cal(e);
                  },
                  enableFeedback: true,
                  icon: Row(
                    children: const [
                      Icon(Icons.edit_calendar),
                      Text("   Add to Calendar")
                    ],
                  ),
                ),
                // OutlinedButton(
                //     onPressed: () {},
                //     child: Text(
                //       "Frequently asked questions",
                //     )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Icon(Icons.place),
                SizedBox(
                  width: 5,
                ),
                Text(event["location"])
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
                "Register for the contest in advance and You can fill out the contact information at the registration step."),
          ),
          const SizedBox(
            height: 10,
          ),

          const ListTile(
            leading: Icon(
              Icons.label_important,
              color: Colors.teal,
            ),
            title: Text("Important Note", textScaleFactor: 1.3),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(event["importantNote"]),
          ),
          // Column(crossAxisAlignment: CrossAxisAlignment.start, children: notes),
          const SizedBox(
            height: 10,
          ),
          const ListTile(
            leading: Icon(
              Icons.announcement_outlined,
              color: Colors.amber,
            ),
            title: Text("Announcement", textScaleFactor: 1.3),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(event['announcement']),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              "Users must register to participate.\nWe hope you will enjoy this event!",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 20,
          ),
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
            const Expanded(
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
            SizedBox(
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
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.favorite_border),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget dialogForRegisterNow(BuildContext context) {
    String name = userSnapshot["nickname"],
        email = userSnapshot['useremail'],
        phone = userSnapshot['phone'];
    bool isOpenToRegister =
        DateTime.now().compareTo(event['lastRegisterationTime'].toDate()) < 0;

    return Dialog(
      child: Container(
          width: 100.w <= 800 ? null : 40.w,
          padding: EdgeInsets.all(8),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Name",
                  textScaleFactor: 1.2,
                ),
                TextFormField(
                  enabled: isOpenToRegister,
                  initialValue: name,
                  onChanged: (s) {
                    name = s;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    contentPadding: const EdgeInsets.only(
                        top: 5, bottom: 5, right: 0, left: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    enabledBorder: null,
                    // isCollapsed: true,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Email",
                  textScaleFactor: 1.2,
                ),
                TextFormField(
                  enabled: isOpenToRegister,
                  initialValue: email,
                  onChanged: (s) {
                    email = s;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    contentPadding: const EdgeInsets.only(
                        top: 5, bottom: 5, right: 0, left: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    enabledBorder: null,
                    // isCollapsed: true,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "contact number",
                  textScaleFactor: 1.2,
                ),
                TextFormField(
                  enabled: isOpenToRegister,
                  initialValue: phone,
                  onChanged: (s) {
                    phone = s;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    contentPadding: const EdgeInsets.only(
                        top: 5, bottom: 5, right: 0, left: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    enabledBorder: null,
                    // isCollapsed: true,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "We dont store your contact number you can enter if you like to be contacted by event organizer.",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                // last date of registration
                isOpenToRegister
                    ? Align(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                          child: Text("Register Now"),
                          onPressed: () async {
                            await handleRegisterNow({
                              "id": userSnapshot.id,
                              "name": name,
                              "branch": userSnapshot['branch'],
                              "rollno": userSnapshot['rollnumber'],
                              "email": email,
                              "phone": phone,
                              "attended": false,
                            });
                            Get.back();
                          },
                        ),
                      )
                    : const Center(
                        child: Chip(
                          label: Text("REGISTERATION CLOSED"),
                          backgroundColor: Colors.red,
                        ),
                      )
              ],
            ),
          )),
    );
  }

  Future handleRegisterNow(Map<String, dynamic> data) async {
    // MongoDB.insertData({
    //   "_id": event.id,
    //   "name": event['title'],
    //   "timestamp": DateTime.now(),
    // });
    event.reference.update({
      "registered": FieldValue.arrayUnion([userEmail])
    });
    await userSnapshot.reference
        .update({'registerations': FieldValue.increment(1)});
    Get.back();
  }

  Future handleUnRegister() async {
    UnimplementedError();
    await event.reference.update({
      "registered": FieldValue.arrayRemove([userEmail])
    });
  }
}
