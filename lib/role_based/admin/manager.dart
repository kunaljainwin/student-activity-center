import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:samadhyan/widgets/is_a.dart';

class AdminRankManager extends StatefulWidget {
  const AdminRankManager({super.key});

  @override
  State<AdminRankManager> createState() => _AdminRankManagerState();
}

class _AdminRankManagerState extends State<AdminRankManager> {
  var db = FirebaseFirestore.instance.collection("users");
  var query = "";
  int queryRank = 0;

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      TextField(
        onChanged: ((value) => setState(() {
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
                            queryRank <= 3 && queryRank >= 1
                                ? {
                                    ds.reference.update(
                                        {"rank": FieldValue.increment(-1)}),
                                    queryRank--,
                                  }
                                : null;
                          },
                          child: Text("Promote")),
                      TextButton(
                          onPressed: () async {
                            queryRank <= 2 && queryRank >= 0
                                ? {
                                    ds.reference.update(
                                        {"rank": FieldValue.increment(1)}),
                                    queryRank++,
                                  }
                                : null;
                          },
                          child: Text("Demote")),
                    ],
                  );
                }
                return Container();
              })
    ]);
  }
}
