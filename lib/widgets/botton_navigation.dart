import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import '../screens/main screens/event_page.dart';
import '../screens/main screens/main_page.dart';
import '../screens/main screens/cast_page.dart';
import '../screens/main screens/comment_page.dart';
import '../screens/main screens/news_page.dart';

class Bottom extends StatefulWidget {
  // ignore: use_super_parameters
  const Bottom({Key? key}) : super(key: key);

  @override
  State<Bottom> createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  // ignore: non_constant_identifier_names
  var index_color = 0;
  List<Widget> screens = [
    const Main(),
    const CastPage(),
    const EventScreen(),
    const CommentScreen(),
    const NewsScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index_color],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: const [
          Icons.home,
          Icons.group,
          Icons.event,
          Icons.comment,
          Icons.newspaper,
        ],
        activeIndex: index_color,
        gapLocation: GapLocation.none,
        notchSmoothness: NotchSmoothness.defaultEdge,
        activeColor: const Color.fromARGB(255, 82, 29, 0),
        inactiveColor: const Color.fromARGB(255, 211, 113, 0),
        backgroundColor: Colors.white,
        height: 60,
        iconSize: 30,
        leftCornerRadius: 20,
        rightCornerRadius: 20,
        onTap: (index) => setState(() => index_color = index), // Remove duplicate onTap here
      ),
    );
  }
}