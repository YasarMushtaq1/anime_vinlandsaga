import 'package:flutter/material.dart';
import 'package:vinlandsaga_pro/widgets/news/news_feed.dart';
import 'package:vinlandsaga_pro/widgets/news/new_news.dart'; 
import 'package:firebase_messaging/firebase_messaging.dart';

class NewsScreen extends StatefulWidget {
  // ignore: use_super_parameters
  const NewsScreen({Key? key}) : super(key: key);

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  void setupPushNotifications() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    fcm.subscribeToTopic('News');
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
        title: const Text('News'), // Updated title
        actions: [
          IconButton(
            onPressed: () {
            },
            icon: Icon(
              Icons.newspaper,
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
            NewNews(), // Updated widget reference
            Expanded(
              child: NewsFeed(),
            ),
          ],
        ),
      ),
    );
  }
}
