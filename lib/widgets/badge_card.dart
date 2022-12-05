import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class BadgeCard extends StatelessWidget {
  final DocumentSnapshot badgeSnapshot;
  final Color color;
  const BadgeCard({Key? key, required this.badgeSnapshot, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              child: Container(
                  width: double.infinity,
                  color: color,
                  height: 40,
                  alignment: Alignment.centerRight,
                  child: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(
                        CupertinoIcons.multiply,
                        color: Colors.black87,
                      ))),
              alignment: Alignment.centerRight,
            ),
            Container(
              height: 100,
              padding: EdgeInsets.only(bottom: 20, left: 20, right: 20),
              clipBehavior: Clip.antiAlias,
              child: SvgPicture.network(
                badgeSnapshot["imageurl"],
                placeholderBuilder: (BuildContext context) =>
                    const SizedBox.expand(),
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(100),
                      bottomRight: Radius.circular(100)),
                  gradient: LinearGradient(
                      tileMode: TileMode.decal,
                      colors: [color, Colors.white],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter)),
            ),
            Text(
              badgeSnapshot["name"],
              textScaleFactor: 1.2,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              badgeSnapshot["description"],
              style: TextStyle(),
              textScaleFactor: 1.1,
            ),
            // Text("Badge Level"),
            // Text("Badge next Level"),
            Text("Badge Progress"),
            Divider(),
            ElevatedButton(
              onPressed: () {},
              child: Text("SHARE"),
            )
          ],
        ),
      ),
    );
  }
}
