import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:samadhyan/constants.dart';
import 'package:samadhyan/widgets/is_a.dart';

class FacultyRankManager extends StatefulWidget {
  const FacultyRankManager({super.key});

  @override
  State<FacultyRankManager> createState() => _FacultyRankManagerState();
}

class _FacultyRankManagerState extends State<FacultyRankManager> {
  var db = FirebaseFirestore.instance.collection("users");
  var query = "";
  var queryRank = 0;
  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      TextField(
        autofillHints: [userEmail],
        onSubmitted: ((value) => setState(() {
              query = value;
            })),
      ),
      query == ""
          ? Container()
          : StreamBuilder<QuerySnapshot<Object>>(
              stream: db.where("useremail", isEqualTo: query).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.waiting &&
                    snapshot.data!.size != 0) {
                  DocumentSnapshot ds = snapshot.data!.docs[0];
                  queryRank = ds["rank"];
                  return AlertDialog(
                    title: Text(ds["nickname"] + " " + isA(rank: ds["rank"])),
                    content: Text(ds["useremail"]),
                    actions: [
                      TextButton(
                          onPressed: () async {
                            queryRank == 3
                                ? {
                                    ds.reference.set({
                                      "rank": 2,
                                      "eventsorganized":
                                          FieldValue.increment(0),
                                    }, SetOptions(merge: true)),
                                  }
                                : null;
                          },
                          child: Text("Promote to Event Coordinator")),
                      TextButton(
                          onPressed: () async {
                            queryRank == 2
                                ? ds.reference.update({"rank": 3})
                                : null;
                          },
                          child: Text("Demote to Student")),
                    ],
                  );
                }
                return Container();
              })
    ]);
  }
}
