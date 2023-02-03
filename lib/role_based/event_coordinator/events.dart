import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:samadhyan/services/qr/mobile_scanner.dart';
import 'package:samadhyan/widgets/round_indicator.dart';
import 'package:sizer/sizer.dart';

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
    _tabController = TabController(length: 2, vsync: this, initialIndex: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Events"),
        bottom: TabBar(
            labelPadding: EdgeInsets.symmetric(horizontal: 10.w),
            labelColor: Colors.purple,
            indicator: RoundedTabIndicator(
                color: Colors.purple, radius: 20, width: 170, bottomMargin: 8),
            indicatorWeight: 4,
            indicatorSize: TabBarIndicatorSize.label,
            isScrollable: true,
            indicatorColor: Colors.blue,
            automaticIndicatorColorAdjustment: true,
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
                  itemBuilder: (context, listSnapshot, index) {
                    return InkWell(
                        key: Key(index.toString()),
                        child: ListTile(
                          title: Text(
                            listSnapshot[index]["title"],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: GoogleFonts.nunito().fontFamily,
                              fontSize: 14,
                            ),
                          ),
                        
                 
                        ),
                        onTap: () => Get.to(() => EventDetails(
                              event: listSnapshot[index],
                            )));
                  },
                  query: FirebaseFirestore.instance
                      .collection("contests")
                      .where("endTime", isLessThan: Timestamp.now())
                      .orderBy("endTime"),
                  itemBuilderType: PaginateBuilderType.listView),
              PaginateFirestore(
                  itemBuilder: (context, listSnapshot, index) {
                    return InkWell(
                        key: Key(index.toString()),
                        child: ListTile(
                          title: Text(
                            listSnapshot[index]["title"],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: GoogleFonts.nunito().fontFamily,
                              fontSize: 14,
                            ),
                          ),
                          trailing: IconButton(
                              onPressed: () => Get.to(() => Scanner(
                                    documentSnapshot: listSnapshot[index],
                                  )),
                              icon: Icon(Icons.qr_code_scanner)),
                        ),
                        onTap: () => Get.to(() => EventDetails(
                              event: listSnapshot[index],
                            )));
                  },
                  query: FirebaseFirestore.instance
                      .collection("contests")
                      .where("endTime", isGreaterThanOrEqualTo: DateTime.now())
                      .orderBy("endTime"),
                  itemBuilderType: PaginateBuilderType.listView),
            ],
          )),
    );
  }
}
