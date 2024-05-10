import 'package:flutter/material.dart';
import 'package:vinlandsaga_pro/widgets/stuff/new_stuff.dart';
import 'package:vinlandsaga_pro/widgets/stuff/stuff_feed.dart'; 
import 'package:firebase_messaging/firebase_messaging.dart';

class StuffScreen extends StatefulWidget {
  // ignore: use_super_parameters
  const StuffScreen({Key? key}) : super(key: key);

  @override
  State<StuffScreen> createState() => _StuffScreenState();
}

class _StuffScreenState extends State<StuffScreen> {
  void setupPushNotifications() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    fcm.subscribeToTopic('Stuff');
  }

  @override
  void initState() {
    super.initState();
    setupPushNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10), // Add some spacing from top
            NewStuff(), // Updated widget reference
            Expanded(
              child: StuffFeed(),
            ),
          ],
        ),
      ),
    );
  }
}
