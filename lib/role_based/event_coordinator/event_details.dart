import 'dart:io';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:samadhyan/Services/QR/mobile_scanner.dart';
import 'package:samadhyan/role_based/event_coordinator/excel.dart';

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
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      body: ListView(
        padding: EdgeInsets.all(8),
        children: [
          getAppBarUI(context),
          Text(event["registered"].toString()),
          Text(event["attendees"].toString()),
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

          // FutureBuilder<Map>(
          //     future: MongoDB.getData(event.id),
          //     builder: (context, snapshot) {
          //       if (snapshot.connectionState == ConnectionState.done &&
          //           snapshot.hasData) {
          //         var ans = snapshot.data!["registered"].toList();
          //         return Container(
          //           height: 100,
          //           child: ListView.builder(
          //             shrinkWrap: true,
          //             itemBuilder: (context, index) {
          //               return ListTile(
          //                 title: Text(ans[index]["name"]),
          //                 leading: Text(ans[index]["rollnumber"].toString()),
          //                 trailing: Text(ans[index]["branch"]),
          //                 subtitle: Text(ans[index]["email"]),
          //               );
          //             },
          //             itemCount: ans.length,
          //           ),
          //         );
          //       }
          //       return Text("Loading");
          //     }),
          Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 10.0),
                height: MediaQuery.of(context).size.height * 0.5,
                child: OptimizedCacheImage(imageUrl: event['eventPosterLink']),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                padding: EdgeInsets.all(40.0),
                width: MediaQuery.of(context).size.width,
                decoration:
                    const BoxDecoration(color: Color.fromRGBO(58, 66, 86, .9)),
                child: const Center(
                  child: Text(
                    "Event Name",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Positioned(
                left: 8.0,
                top: 60.0,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back, color: Colors.white),
                ),
              )
            ],
          ),
          Container(
              child: Row(
            children: [
              IconButton(onPressed: () {}, icon: Icon(Icons.facebook)),
              IconButton(onPressed: () {}, icon: Icon(Icons.radio)), // twitter
              IconButton(
                  onPressed: () {}, icon: Icon(Icons.linked_camera_outlined)),
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
            ],
          )),
          Text("Welcome to the " + event['title'], textScaleFactor: 1.4),
          Text(
              "Register for the contest in advance and You can fill out the contact information at the registration step."),
          Text(
              " we may reach out to eligible contest winners for Rewards and Prizes."),
          ListTile(
            leading: Icon(Icons.label_important),
            title: Text("Important Note", textScaleFactor: 1.2),
          ),
          // Column(crossAxisAlignment: CrossAxisAlignment.start, children: notes),
          ListTile(
            leading: Icon(Icons.announcement),
            title: Text("Announcement", textScaleFactor: 1.2),
          ),
          Text(event['announcement']),
          SizedBox(
            height: 10,
          ),
          Text(
              "Users must register to participate. We hope you enjoy this event!"),
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
