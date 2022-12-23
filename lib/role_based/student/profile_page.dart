import 'package:flutter/material.dart';
import 'package:samadhyan/constants.dart';
import 'package:samadhyan/widgets/login_helpers.dart';
import 'package:samadhyan/widgets/title_box.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(8),
        children: [
          titleBox("Name"),
          Text(userName),
          titleBox("Email"),
          Text(userEmail),
          titleBox("Branch"),
          Text(userSnapshot['branch']),
          titleBox("Roll Number"),
          Text(userSnapshot['rollnumber'].toString()),
        ],
      ),
    );
  }
}
