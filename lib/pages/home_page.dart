import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smarthomeui/pages/assistance.dart';
import 'package:smarthomeui/pages/camera.dart';
import 'package:smarthomeui/pages/dashboard.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  List<Widget> tabItems = const [
    DashboardPage(),
    MyAssistancePage(),
    // LiveStreamScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: tabItems[_selectedIndex],
      ),
      bottomNavigationBar: FlashyTabBar(
        animationCurve: Curves.linear,
        selectedIndex: _selectedIndex,
        iconSize: 30,
        showElevation: false, // use this to remove appBar's elevation
        onItemSelected: (index) => setState(() {
          _selectedIndex = index;
        }),
        items: [
          FlashyTabBarItem(
            icon: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
          ),
          FlashyTabBarItem(
            icon: const Icon(Icons.assistant),
            title: const Text('Assistance'),
          ),
          FlashyTabBarItem(
            icon: const Icon(Icons.camera),
            title: const Text('Camera'),
          ),
        ],
      ),
    );
  }
}
