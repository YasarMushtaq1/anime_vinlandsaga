import 'package:flutter/material.dart';
import 'package:vinlandsaga_pro/widgets/calendar/event_feed.dart';
import 'package:vinlandsaga_pro/widgets/calendar/new_event.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class EventScreen extends StatefulWidget {
  // ignore: use_super_parameters
  const EventScreen({Key? key}) : super(key: key);

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  void setupPushNotifications() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    fcm.subscribeToTopic('Events');
  }

  @override
  void initState() {
    super.initState();
    setupPushNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'), // Updated title
        actions: [
          IconButton(
            onPressed: () {
              //
            },
            icon: Icon(
              Icons.event,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
        shape: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.5),
            width: 0.5,
          ),
        ),
      ),
      body: const SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10), // Add some spacing from top
            NewEvent(), // Updated widget reference
            Expanded(
              child: EventFeed(),
            ),
          ],
        ),
      ),
    );
  }
}
