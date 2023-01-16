import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:samadhyan/constants.dart';
import 'package:samadhyan/widgets/badge_card.dart';
import 'package:samadhyan/widgets/login_helpers.dart';

class AchievementsPage extends StatelessWidget {
  final DocumentSnapshot userData;
  final num level;
  const AchievementsPage(
      {Key? key,
      required this.userData,
      required this.level,
})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Achievements"),
          // bottom: TabBar(tabs: [Tab(text: "Stats",),Tab(text: "Badges")]),
          // bottom: TabBar(tabs: [
          //   Tab(
          //     text: "Stats",
          //   ),
          //   Tab(
          //     text: "Badges",
          //   )
          // ]),
        ),
        body: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(18),
            children: [
              Container(
                padding: EdgeInsets.zero,
                height: 400,
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.blueGrey.shade400),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  children: [
                    Container(
                      height: 196,
                      decoration: const BoxDecoration(
                          border: Border.symmetric(
                              // vertical: BorderSide(
                              //     width: 2, color: Colors.blueGrey.shade400),
                              // horizontal: BorderSide(
                              //     width: 2, color: Colors.blueGrey.shade400),
                              ),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(18),
                              topRight: Radius.circular(18)),
                          image: DecorationImage(
                              image: OptimizedCacheImageProvider(
                                  "https://media3.giphy.com/media/l378BkyZPamSNIQIo/200w.webp?cid=ecf05e47au8hg6aetg10l9ly2wsxjohdekym5sn3ef28vjl5&rid=200w.webp&ct=g"),
                              opacity: 1,
                              fit: BoxFit.fill)),
                      padding: EdgeInsets.only(top: 20, left: 20),
                      child: Row(
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                    text: "\nLevel\n",
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white.withOpacity(0.5))),
                                TextSpan(
                                    text: level.toString(),
                                    style: const TextStyle(
                                        fontSize: 50, color: Colors.white))
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text.rich(
                            TextSpan(children: [
                              TextSpan(
                                  text: "More  ",
                                  style: TextStyle(fontSize: 20)),
                              WidgetSpan(
                                  child: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.lightBlue,
                                size: 20,
                              ))
                            ]),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Divider(
                        thickness: 2,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text.rich(TextSpan(children: [
                              TextSpan(
                                  text: "Total Registerations : " +
                                      userSnapshot["registerations"]
                                          .toString() +
                                      "\n",
                                  style: TextStyle(fontSize: 24)),
                              TextSpan(
                                  text: "Total Attendance : " +
                                      userSnapshot["attendance"].toString(),
                                  style: TextStyle(
                                      fontSize: 24, color: Colors.black87))
                            ])),
                            // OutlinedButton(
                            //   onPressed: () => Get.to(() => MyPlaces()),
                            //   child: Text.rich(TextSpan(children: [
                            //     TextSpan(
                            //         text: "Details",
                            //         style: TextStyle(fontSize: 18)),
                            //   ])),
                            // )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
                child: Divider(
                  thickness: 1,
                ),
              ),
              !devMode
                  ? PaginateFirestore(
                      shrinkWrap: true,
                      isLive: true,
                      header: SliverToBoxAdapter(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.tealAccent,
                              // backgroundImage: const CachedNetworkImageProvider(
                              //   "https://image.shutterstock.com/image-vector/light-green-vector-abstract-mosaic-600w-1033988263.jpg",
                              // ),
                              child: Text(
                                level.toString(),
                                textScaleFactor: 1.5,
                              ),
                            ),
                            CircularProgressIndicator.adaptive(
                              value: level / 20,
                            ),
                          ],
                        ),
                      ),
                      padding: EdgeInsets.all(8),
                      itemBuilder: (context, snapshot, index) {
                        return InkWell(
                          onTap: () async {
                            // var a = await PaletteGenerator.fromImageProvider(
                            //   CachedNetworkImageProvider(
                            //       snapshot[index]["imageurl"]),
                            // );
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return BadgeCard(
                                      badgeSnapshot: snapshot[index],
                                      color: Colors.lightGreen.shade100
                                      //  a.dominantColor?.color ?? Colors.white,
                                      );
                                });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.network(
                              snapshot[index]["imageurl"],
                              placeholderBuilder: (BuildContext context) =>
                                  const CircularProgressIndicator(),
                            ),
                          ),
                        );
                      },
                      onEmpty: SizedBox(
                        height: 0,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4),
                      bottomLoader: Text("Hang on"),
                      query: FirebaseFirestore.instance
                          .collection("badges")
                          .where("users", arrayContains: userData.id),
                      itemBuilderType: PaginateBuilderType.gridView)
                  : SizedBox(
                      height: 0,
                    ),

              // Text(
              //   "Badges",
              //   textScaleFactor: 1.2,
              // ),
              // SizedBox(
              //   height: 20,
              // ),
            ]));
  }
}
