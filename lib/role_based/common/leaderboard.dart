import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:samadhyan/widgets/login_helpers.dart';
import 'package:samadhyan/widgets/modified_dropdown.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({Key? key}) : super(key: key);

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  num rank = -1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Key _key = GlobalKey();

    return Scaffold(
      appBar: AppBar(
        title: Text("Leaderboard"),
        leading: IconButton(
          icon: Icon(CupertinoIcons.multiply),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      // bottomNavigationBar: BottomAppBar(
      //   elevation: 100,
      //   child: ListTile(
      //     enabled: true,
      //     title: rank != -1
      //         ? Text(
      //             "Rank" + " | " + NumberFormat.decimalPattern().format(rank)
      //             //+ getDayOfMonthSuffix(rank % 31 as int)
      //             ,
      //             style: TextStyle(
      //               fontSize: 18,
      //             ),
      //           )
      //         : Text("🚫No data to show Rank"),
      //     // leading: CircleAvatar(
      //     //   foregroundImage:
      //     //       CachedNetworkImageProvider(userSnapshot["imageurl"]),
      //     // ),
      //     subtitle: Text("Keep contributing to get a better rank"),
      //     trailing: Text(
      //       "Visits\n" + userSnapshot["registerations"].toString(),
      //       textAlign: TextAlign.center,
      //     ),
      //   ),
      // ),
      body: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [Colors.orange, Colors.white, Colors.green],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                tileMode: TileMode.repeated),
            boxShadow: const [
              BoxShadow(color: Colors.blue, spreadRadius: 2, blurRadius: 20)
            ],
            borderRadius: BorderRadius.circular(10)),
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 100,
          child: PaginateFirestore(
              key: _key,
              shrinkWrap: true,
              itemsPerPage: 7,
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              itemBuilder: (context, snapshot, index) {
                if (snapshot[index]["useremail"] == userSnapshot["useremail"]) {
                  rank = index + 1;
                }
                return Wrap(
                  children: [
                    Text("${index + 1}. "),
                    ListTile(
                      isThreeLine: true,
                      selected: rank == index + 1,
                      enabled: rank == index + 1,
                      tileColor: Colors.white,

                      subtitle: Text(snapshot[index]["useremail"]),
                      // leading: CircleAvatar(
                      //   foregroundImage: CachedNetworkImageProvider(
                      //       snapshot[index]["imageurl"]),
                      // ),
                      title: Text(snapshot[index]["nickname"]),
                      // subtitle: Text(snapshot[index]["home"].latitude.toString() +
                      //     " , " +
                      //     snapshot[index]["home"].longitude.toString()),
                      trailing: Text(
                        "Visits\n" +
                            snapshot[index]["registerations"].toString(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                );
              },
              initialLoader: CircularProgressIndicator(),
              query: FirebaseFirestore.instance
                  .collection("users")
                  .orderBy("registerations", descending: true),
              itemBuilderType: PaginateBuilderType.listView),
        ),
      ),
    );
  }
}
