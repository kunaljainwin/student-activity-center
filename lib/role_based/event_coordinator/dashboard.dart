import 'package:flutter/material.dart';

import 'events.dart';
import 'home.dart';

class EventCoordinatorDashboard extends StatefulWidget {
  const EventCoordinatorDashboard({super.key});

  @override
  State<EventCoordinatorDashboard> createState() =>
      _EventCoordinatorDashboardState();
}

class _EventCoordinatorDashboardState extends State<EventCoordinatorDashboard> {
  final _screens = const [
    EventCoordinatorHome(),
    EventCoordinatorEvents(),
  ];
  int _currentIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _screens[_currentIndex],
        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          animationDuration: const Duration(seconds: 1),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.account_box_outlined),
              label: "Profile",
              selectedIcon: Icon(Icons.account_box),
              tooltip: 'Navigate to the Dashboard',
            ),
            NavigationDestination(icon: Icon(Icons.event), label: "My Events"),
          ],
        )

        //  BottomNavigationBar(
        //     currentIndex: _currentIndex,
        //     onTap: (value) => {
        //           setState(() => {_currentIndex = value})
        //         },
        //     items: [
        //       BottomNavigationBarItem(
        //           icon: Icon(Icons.account_box), label: "Profile"),
        //       BottomNavigationBarItem(icon: Icon(Icons.event), label: "My Events")
        //     ]),
        );
  }
}
