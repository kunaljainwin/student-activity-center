import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:samadhyan/role_based/common/event_details.dart';
import 'package:samadhyan/widgets/title_box.dart';
import 'package:sizer/sizer.dart';
import 'package:timeago/timeago.dart' as timeago;

class Events extends StatefulWidget {
  const Events({super.key, required this.query, required this.title});
  final Query<Object?> query;
  final String title;
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
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: PaginateFirestore(
          onEmpty: const Text('No Events'),
          itemBuilder: (context, listSnapshot, index) {
            return InkWell(
                key: Key(index.toString()),
                child: cardBuilder(context, listSnapshot[index], index),
                onTap: () => Get.to(() => EventDetails(
                      event: listSnapshot[index],
                    )));
          },
          query: widget.query.orderBy("endTime", descending: true),
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
  const textStyle2 = TextStyle(fontSize: 18);
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
    padding: 100.w <= 800
        ? EdgeInsets.only(left: 24, right: 4.sp, top: 8, bottom: 16)
        : EdgeInsets.only(left: 15.w, right: 20.w, top: 8.h, bottom: 4.h),
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
        child: Card(
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Stack(
                      children: [
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: OptimizedCacheImage(
                            imageUrl: eventPosterLink,
                            errorWidget: (context, url, error) => const Icon(
                              Icons.error,
                              size: 50,
                            ),
                            fit: BoxFit.cover,
                          ),
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
                    ListTile(
                      title: Text(event["title"].toString().capitalizeFirst!,
                          textAlign: TextAlign.left, style: textStyle2),
                      subtitle: Wrap(
                        spacing: 4,
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 16,
                          ),
                          Text(
                            isOngoing
                                ? "Start at ${timeago.format(eventStartDateTime.toDate()).toString()}"
                                : "Ended ${timeago.format(eventEndDateTime.toDate()).toString()}",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                      trailing: titleBox(totalRegistered.toString()),
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
    ),
  );
}
