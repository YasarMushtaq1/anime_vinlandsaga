import 'package:flutter/material.dart';
import 'package:vinlandsaga_pro/widgets/actor/actor_feed.dart';
import 'package:vinlandsaga_pro/widgets/actor/new_actor.dart'; 
import 'package:firebase_messaging/firebase_messaging.dart';

class Actorcreen extends StatefulWidget {
  // ignore: use_super_parameters
  const Actorcreen({Key? key}) : super(key: key);

  @override
  State<Actorcreen> createState() => _ActorcreenState();
}

class _ActorcreenState extends State<Actorcreen> {
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
            NewActor(), // Updated widget reference
            Expanded(
              child: ActorFeed(),
            ),
          ],
        ),
      ),
    );
  }
}
