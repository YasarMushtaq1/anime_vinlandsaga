import 'package:flutter/material.dart';
import 'package:vinlandsaga_pro/widgets/comments/commeted.dart';
import 'package:vinlandsaga_pro/widgets/comments/new_comment.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class CommentScreen extends StatefulWidget {
  // ignore: use_super_parameters
  const CommentScreen({Key? key}) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  void setupPushNotifications() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    fcm.subscribeToTopic('Comments');
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
        title: const Text('Comments'),
        actions: [
          IconButton(
            onPressed: () {
            },
            icon: Icon(
              Icons.comment,
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
            NewComment(), // NewMessage widget at the top
            Expanded(
              child: Commented(),
            ),
          ],
        ),
      ),
    );
  }
}
