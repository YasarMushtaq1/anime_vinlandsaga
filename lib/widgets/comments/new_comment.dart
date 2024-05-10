// ignore_for_file: use_key_in_widget_constructors, prefer_final_fields, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewComment extends StatefulWidget {
  const NewComment({Key? key});

  @override
  State<NewComment> createState() => _NewCommentState();
}

class _NewCommentState extends State<NewComment> {
  var _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _submitMessage() async {
    final enteredMessage = _messageController.text;
    if (enteredMessage.trim().isEmpty) {
      return;
    }
    FocusScope.of(context).unfocus();
    _messageController.clear();

    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    FirebaseFirestore.instance.collection('chat').add({
      'text': enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData.data()!['username'],
      'userImage': userData.data()!['image_url'],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0), // Add padding
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),// Add border radius
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _messageController,
                    maxLines: null, // Allow multiple lines
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    decoration: const InputDecoration(
                      hintText: 'What\'s on your mind?',
                      border: InputBorder.none, // Remove border from text field
                      filled: true,
                      fillColor: Colors.transparent, // Transparent color
                      contentPadding: EdgeInsets.all(10),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _submitMessage,
                    child: const Text(
                      'Comment',
                      style: TextStyle(
                          color: Color.fromARGB(255, 82, 29, 0)),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 211, 113, 0),
                      ), // Change color here
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
