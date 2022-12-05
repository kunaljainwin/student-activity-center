import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_countdown_timer/countdown.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:samadhyan/constants.dart';
import 'package:samadhyan/Services/mongo.dart';
import 'package:samadhyan/widgets/login_helpers.dart';
import 'package:samadhyan/Services/QR/mobile_scanner.dart';
import 'dart:math' as math;

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
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // leadingWidth: 20,
        // toolbarHeight: 30,
        // toolbarOpacity: 0,
        backgroundColor: Colors.transparent,
      ),
      // appBar: AppBar(),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 18),
        children: [
          // getAppBarUI(context),
          Container(
            padding: EdgeInsets.all(14),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(width: 50, color: Colors.lightBlue),
              ),
            ),
            child: Row(
              children: [
                Text("Event will begin in  "),
                CountdownTimer(
                  endTime: endTime,
                ),
              ],
            ),
          ),
          Stack(
            children: <Widget>[
              Container(
                  height: MediaQuery.of(context).size.height * 0.45,
                  padding: EdgeInsets.all(20.0),
                  child: OptimizedCacheImage(
                    imageUrl: event['eventPosterLink'],
                    fit: BoxFit.contain,
                  )),
              Container(
                height: MediaQuery.of(context).size.height * 0.45,
                padding: EdgeInsets.all(40.0),
                // width: MediaQuery.of(context).size.width,
                decoration:
                    BoxDecoration(color: Color.fromRGBO(58, 66, 86, .7)),
                child: Center(
                  child: Text(
                    event['title'],
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              // Positioned(
              //   left: 8.0,
              //   top: 60.0,
              //   child: InkWell(
              //     onTap: () {
              //       Navigator.pop(context);
              //     },
              //     child: Icon(Icons.arrow_back, color: Colors.white),
              //   ),
              // )
            ],
          ),

          Container(
            height: 60,
            padding: EdgeInsets.all(10),
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: [
                SizedBox(
                  width: 20,
                ),
                OutlinedButton(
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
                    child: Row(
                      children: const [
                        Icon(Icons.edit_calendar),
                        Text("   Add to Calendar")
                      ],
                    )),
                SizedBox(
                  width: 20,
                ),
                ActionChip(
                    avatar: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(math.pi),
                        child: Icon(
                          Icons.reply_outlined,
                        )),
                    label: Text("Share")),
                SizedBox(
                  width: 20,
                ),
                ActionChip(
                  avatar: Icon(Icons.thumb_up_off_alt),
                  label: Text("Like"),
                  // onPressed: () => {},
                  // tooltip: "Like",
                ),
                SizedBox(
                  width: 30,
                ),
                OutlinedButton(
                    onPressed: () {},
                    child: Text(
                      "Frequently asked questions",
                    )),
              ],
            ),
          ),

          Text(
              "Register for the contest in advance and You can fill out the contact information at the registration step."),
          Text(
              " we may reach out to eligible contest winners for Rewards and Prizes."),
          ListTile(
            leading: Icon(
              Icons.label_important,
              color: Colors.teal,
            ),
            title: Text("Important Note", textScaleFactor: 1.3),
          ),
          // Column(crossAxisAlignment: CrossAxisAlignment.start, children: notes),
          ListTile(
            leading: Icon(
              Icons.announcement_outlined,
              color: Colors.amber,
            ),
            title: Text("Announcement", textScaleFactor: 1.3),
          ),
          Text(event['announcement']),

          Text(
              "Users must register to participate. We hope you enjoy this event!"),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                isRegistered
                    ? Icon(Icons.done_outline)
                    : ActionChip(
                        backgroundColor: Colors.black,
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return DialogForRegisterNow(context);
                              });
                        },
                        tooltip: "Register Now",
                        label: const Text(
                          "Register Now",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
              ],
            ),
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

  Widget DialogForRegisterNow(BuildContext context) {
    String name = userName, email = userEmail, phone = userContactNumber;
    bool isOpenToRegister =
        DateTime.now().compareTo(event['lastRegisterationTime'].toDate()) < 0;

    return Dialog(
      child: Container(
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
                              "_id": userSnapshot.id,
                              "name": name,
                              "email": email,
                              "phone": phone
                            });
                            Get.back();
                          },
                        ),
                      )
                    : Center(
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
    // await MongoDB.insertData(data);
    await event.reference.update({
      "registered": FieldValue.arrayUnion([userEmail])
    });
    Get.back();
  }

  Future handleUnRegister() async {
    UnimplementedError();
    await event.reference.update({
      "registered": FieldValue.arrayRemove([userEmail])
    });
  }
}
