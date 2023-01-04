import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:xpressnepal/screen/DashboardScreen.dart';
import 'package:xpressnepal/screen/IncomeHistory.dart';
import 'package:xpressnepal/screen/OrderHistory.dart';
import 'package:xpressnepal/screen/Profile.dart';

class ButtonNavbar extends StatefulWidget {
  const ButtonNavbar({super.key});

  @override
  State<ButtonNavbar> createState() => _ButtonNavbarState();
}

class _ButtonNavbarState extends State<ButtonNavbar> {
  var _currentIndex = 0;

  // list of widgets
  final List<Widget> _children = [
    DashboardScreen(),
    OrderHistory(),
    IncomeHistory(),
    Profile()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          /// Home
          SalomonBottomBarItem(
            icon: const Icon(Icons.directions_bike),
            title: const Text("Orders"),
            selectedColor: Colors.black,
          ),

          /// Likes
          SalomonBottomBarItem(
            icon: const Icon(Icons.history),
            title: const Text("History"),
            selectedColor: Colors.black,
          ),

          /// Search
          SalomonBottomBarItem(
            icon: const Icon(Icons.currency_exchange),
            title: const Text("Earning"),
            selectedColor: Color.fromARGB(255, 0, 0, 0),
          ),

          /// Profile
          SalomonBottomBarItem(
            icon: const Icon(Icons.person),
            title: const Text("Profile"),
            selectedColor: Colors.black,
          ),
        ],
      ),

    );
  }
}
