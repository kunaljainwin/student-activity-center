import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import 'create_event.dart';

class EventCoordinatorHome extends StatelessWidget {
  const EventCoordinatorHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async => {Get.to(() => const CreateEvent())},
        label: Text("Add Event"),
        icon: Icon(Icons.add),
      ),
    );
  }
}
