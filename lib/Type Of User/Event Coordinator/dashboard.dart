import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'events.dart';
import 'home.dart';

class EventCoordinatorDashboard extends StatefulWidget {
  const EventCoordinatorDashboard({super.key});

  @override
  State<EventCoordinatorDashboard> createState() =>
      _EventCoordinatorDashboardState();
}

class _EventCoordinatorDashboardState extends State<EventCoordinatorDashboard> {
  var _screens = [
    EventCoordinatorHome(),
    EventCoordinatorEvents(),
  ];
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (value) => {
                setState(() => {_currentIndex = value})
              },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.account_box), label: "Profile"),
            BottomNavigationBarItem(icon: Icon(Icons.event), label: "My Events")
          ]),
    );
  }
}
