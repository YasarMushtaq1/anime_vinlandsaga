import 'package:flutter/material.dart';
import '../screens/side screens/actors.dart';
import '../screens/side screens/stuff.dart';

class AppBarNavigation extends StatefulWidget {
  // ignore: use_super_parameters
  const AppBarNavigation({Key? key}) : super(key: key);

  @override
  State<AppBarNavigation> createState() => _AppBarNavigationState();
}

class _AppBarNavigationState extends State<AppBarNavigation> {
  // Index for current selected tab
  int _currentIndex = 0;

  // List of screens corresponding to each tab
  final List<Widget> _screens = [
    const Actorcreen(),
    const StuffScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _screens.length,
      initialIndex: _currentIndex,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cast'),
          bottom: TabBar(
            labelColor: const Color.fromARGB(255, 82, 29, 0),
            tabs: const [
              Tab(text: 'Actors',),
              Tab(text: 'Stuff'),
            ],
            onTap: (index) => setState(() => _currentIndex = index),
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: _screens, // Disable swipe between tabs
        ),
      ),
    );
  }
}
