import 'package:flutter/material.dart';

import 'home.dart';
import 'manager.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final _screens = const [
    AdminHome(),
    AdminRankManager(),
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
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.account_box), label: "Profile"),
            BottomNavigationBarItem(
                icon: Icon(Icons.control_point_duplicate_sharp),
                label: "Manage Admins")
          ]),
    );
  }
}
