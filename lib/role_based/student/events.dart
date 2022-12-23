import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:samadhyan/role_based/student/event_details.dart';
import 'package:timeago/timeago.dart' as timeago;

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PaginateFirestore(
          isLive: true,
          onEmpty: const Text('No Events'),
          itemBuilder: (context, listSnapshot, index) {
            return InkWell(
                key: Key(index.toString()),
                child: cardBuilder(context, listSnapshot[index], index),
                onTap: () => Get.to(() => EventDetails(
                      event: listSnapshot[index],
                    )));
          },
          query: FirebaseFirestore.instance.collection("contests"),
          // .where("endTime", isGreaterThanOrEqualTo: Timestamp.now())
          // .orderBy("endTime", descending: true),
          itemBuilderType: PaginateBuilderType.listView),
    );
  }
}

Widget cardBuilder(BuildContext context, DocumentSnapshot event, int index) {
  final eventPosterLink = event["eventPosterLink"];
  final eventTitle = event["title"];
  final eventStartDateTime = event["startTime"];
  final eventEndDateTime = event["endTime"];
  final eventVenue = event["location"];
  num totalAttendees = event["attendees"].length;
  num totalRegistered = event["registered"].length + totalAttendees;
  var isOngoing = DateTime.now().compareTo(event["endTime"].toDate()) < 0;
  const textStyle2 = TextStyle(fontSize: 20);
  var textStyleCountdown = const TextStyle(
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
  );
  return Padding(
    padding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 16),
    child: InkWell(
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
                        OptimizedCacheImage(
                          imageUrl: eventPosterLink,
                          errorWidget: (context, url, error) => const Icon(
                            Icons.error,
                            size: 50,
                          ),
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                            bottom: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.timelapse,
                                    color: Colors.white,
                                  ),
                                  CountdownTimer(
                                    endTime: eventStartDateTime
                                        .millisecondsSinceEpoch,
                                    endWidget: isOngoing
                                        ? Container(
                                            color: Colors.green,
                                            child: const Text(
                                              "Event Started",
                                              style: textStyle2,
                                            ),
                                          )
                                        : Container(
                                            color: Colors.red,
                                            child: const Text(
                                              "Event Ended",
                                              style: textStyle2,
                                            ),
                                          ),
                                    textStyle: textStyleCountdown,
                                  ),
                                ],
                              ),
                            ))
                      ],
                    ),
                  ),
                  Row(
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
                              Text(event["title"].toString().capitalizeFirst!,
                                  textAlign: TextAlign.left, style: textStyle2),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Chip(
                                    avatar: const Icon(
                                      Icons.location_pin,
                                      size: 16,
                                    ),
                                    label: Text(eventVenue,
                                        overflow: TextOverflow.ellipsis,
                                        style: textStyle2),
                                  ),
                                  Chip(
                                    avatar: const Icon(
                                      Icons.calendar_today,
                                      size: 16,
                                    ),
                                    label: Text(
                                      timeago
                                          .format(eventStartDateTime.toDate())
                                          .toString(),
                                      // style: TextStyle(
                                      //   fontSize: 14,
                                      // ),
                                    ),
                                  ),
                                ],
                              ),
                              isOngoing
                                  ? Text(
                                      "Start at ${event["startTime"].toDate()}")
                                  : Text(
                                      "Ended ${event["endTime"].toDate().toString()}",
                                    )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Positioned(
              //     top: 8,
              //     right: 8,
              //     child: IconButton(
              //         isSelected: true,
              //         disabledColor: Colors.grey,
              //         color: Colors.grey,
              //         onPressed: () {
              //           Event e = Event(
              //             title: eventTitle,
              //             description: event['description'],
              //             location: eventVenue,
              //             startDate: eventStartDateTime.toDate(),
              //             endDate: eventEndDateTime.toDate(),
              //           );

              //           Add2Calendar.addEvent2Cal(e);
              //         },
              //         style: IconButton.styleFrom(
              //             backgroundColor: Colors.grey.withOpacity(0.5)),
              //         icon: const Icon(
              //           Icons.calendar_today_rounded,
              //         )))
            ],
          ),
        ),
      ),
    ),
  );
}
