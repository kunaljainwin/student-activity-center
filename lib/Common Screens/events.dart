import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:samadhyan/Common%20Screens/event_details.dart';
import 'package:timeago/timeago.dart' as timeago;

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Icon(
            Icons.currency_bitcoin,
            color: Color.fromARGB(255, 255, 217, 0),
            size: 40,
          ),
          Center(
            child: Text(
              100.toString(),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
      body: PaginateFirestore(
          isLive: true,
          onEmpty: Text('No Events'),
          itemBuilder: (context, listSnapshot, index) {
            return InkWell(
                key: Key(index.toString()),
                child: cardBuilder(context, listSnapshot[index], index),
                onTap: () => Get.to(() => EventDetails(
                      event: listSnapshot[index],
                    )));
          },
          query: FirebaseFirestore.instance
              .collection("contests")
              .where("endTime", isGreaterThanOrEqualTo: Timestamp.now())
              .orderBy("endTime", descending: true),
          itemBuilderType: PaginateBuilderType.listView),
    );
  }
}

Widget cardBuilder(
    BuildContext context, DocumentSnapshot documentSnapshot, int index) {
  return Padding(
    padding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 16),
    child: InkWell(
      // splashColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.withOpacity(0.6),
              offset: const Offset(4, 4),
              blurRadius: 16,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 2,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          documentSnapshot["eventPosterLink"],
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                            bottom: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.timelapse,
                                    color: Colors.white,
                                  ),
                                  CountdownTimer(
                                    endTime: documentSnapshot['startTime']
                                        .millisecondsSinceEpoch,
                                    endWidget: DateTime.now().compareTo(
                                                documentSnapshot["endTime"]
                                                    .toDate()) <
                                            0
                                        ? Container(
                                            color: Colors.green,
                                            child: Text(
                                              "Event Started",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                          )
                                        : Container(
                                            color: Colors.red,
                                            child: Text(
                                              "Event Ended",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                          ),
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 10.0,
                                          color: Colors.black,
                                          offset: Offset(5.0, 5.0),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ))
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 16, top: 8, bottom: 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  documentSnapshot["title"],
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Chip(
                                      avatar: Icon(
                                        Icons.location_pin,
                                        size: 16,
                                      ),
                                      label: Text(
                                        documentSnapshot["location"],
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    Chip(
                                      avatar: Icon(
                                        Icons.calendar_today,
                                        size: 16,
                                      ),
                                      label: Text(
                                        timeago
                                            .format(
                                                documentSnapshot["startTime"]
                                                    .toDate())
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                      isSelected: true,
                      disabledColor: Colors.grey,
                      color: Colors.grey,
                      onPressed: () {
                        Event e = Event(
                          title: documentSnapshot['title'],
                          description: documentSnapshot['description'],
                          location: documentSnapshot['location'].toString(),
                          startDate: documentSnapshot["startTime"].toDate(),
                          endDate: documentSnapshot["endTime"].toDate(),
                        );

                        Add2Calendar.addEvent2Cal(e);
                      },
                      style: IconButton.styleFrom(
                          backgroundColor: Colors.grey.withOpacity(0.5)),
                      icon: Icon(
                        Icons.calendar_today_rounded,
                        color: Theme.of(context).cardColor,
                      )))
            ],
          ),
        ),
      ),
    ),
  );
}
