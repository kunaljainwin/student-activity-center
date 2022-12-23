import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

import 'event_details.dart';

class EventCoordinatorEvents extends StatefulWidget {
  const EventCoordinatorEvents({super.key});

  @override
  State<EventCoordinatorEvents> createState() => _EventCoordinatorEventsState();
}

class _EventCoordinatorEventsState extends State<EventCoordinatorEvents>
    with TickerProviderStateMixin {
  var _tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Events"),
        backgroundColor: Colors.orangeAccent,
        bottom: TabBar(
            controller: _tabController,
            // labelStyle: TextStyle(fontSize: 12, color: Colors.purple),
            // indicatorSize: TabBarIndicatorSize.label,
            // automaticIndicatorColorAdjustment: true,
            onTap: (val) {
              _tabController.animateTo(val);
            },
            tabs: [
              Tab(
                iconMargin: EdgeInsets.only(bottom: 8),
                text: "Completed",
              ),
              Tab(
                iconMargin: EdgeInsets.only(bottom: 8),
                text: "Upcoming",
              )
            ]),
      ),
      body: DefaultTabController(
          length: 2,
          initialIndex: _tabController.index,
          child: TabBarView(
            controller: _tabController,
            children: [
              PaginateFirestore(
                  isLive: true,
                  itemBuilder: (context, listSnapshot, index) {
                    return InkWell(
                        key: Key(index.toString()),
                        child: ListTile(
                          title: Text(listSnapshot[index]["title"]),
                        ),
                        onTap: () => Get.to(() => EventDetails(
                              event: listSnapshot[index],
                            )));
                  },
                  query: FirebaseFirestore.instance
                      .collection("contests")
                      .where("endTime", isLessThan: DateTime.now()),
                  itemBuilderType: PaginateBuilderType.listView),
              PaginateFirestore(
                  isLive: true,
                  itemBuilder: (context, listSnapshot, index) {
                    return InkWell(
                        key: Key(index.toString()),
                        child: ListTile(
                          title: Text(listSnapshot[index]["title"]),
                        ),
                        onTap: () => Get.to(() => EventDetails(
                              event: listSnapshot[index],
                            )));
                  },
                  query: FirebaseFirestore.instance
                      .collection("contests")
                      .where("endTime", isGreaterThanOrEqualTo: DateTime.now()),
                  itemBuilderType: PaginateBuilderType.listView),
            ],
          )),
    );
  }
}
