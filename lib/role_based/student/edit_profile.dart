import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Additional info"),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Get.back(), label: Text("Ask me later")),
    );
  }
}
