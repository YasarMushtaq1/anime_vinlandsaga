// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Commented extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const Commented({Key? key});

  @override
  Widget build(BuildContext context) {
    final authUser = FirebaseAuth.instance.currentUser!;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (ctx, chatSnapshots) {
        if (chatSnapshots.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
          return const Center(
            child: Text('No messages found'),
          );
        }
        if (chatSnapshots.hasError) {
          return const Center(
            child: Text('Something went wrong...'),
          );
        }
        final loadedMessages = chatSnapshots.data!.docs;
        return ListView.builder(
          padding: const EdgeInsets.only(
            bottom: 40,
            left: 13,
            right: 13,
          ),
          reverse: true,
          itemCount: loadedMessages.length,
          itemBuilder: (ctx, index) {
            final chatMessage = loadedMessages[index].data();
            final nextChatMessage = index + 1 < loadedMessages.length
                ? loadedMessages[index + 1].data()
                : null;
            final currentMessageUserId = chatMessage['userId'];
            final nextMessageUserId =
                nextChatMessage != null ? nextChatMessage['userId'] : null;
            final nextUserIsSame = nextMessageUserId == currentMessageUserId;

            return CommentCard(
              messageId: loadedMessages[index].id,
              userImage: chatMessage['userImage'],
              username: chatMessage['username'],
              time: chatMessage['createdAt'],
              text: chatMessage['text'],
              isMe: authUser.uid == currentMessageUserId,
              nextUserIsSame: nextUserIsSame,
            );
          },
        );
      },
    );
  }
}

class CommentCard extends StatefulWidget {
  final String messageId;
  final String username;
  final Timestamp time;
  final String text;
  final String userImage;
  final bool isMe;
  final bool nextUserIsSame;

  // ignore: use_super_parameters
  const CommentCard({
    required this.messageId,
    required this.username,
    required this.time,
    required this.text,
    required this.userImage,
    required this.isMe,
    required this.nextUserIsSame,
    Key? key,
  }) : super(key: key);

  @override
  _CommentCardState createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  // ignore: prefer_final_fields
  TextEditingController _editController = TextEditingController();

  // Function to delete a message
  Future<void> _deleteMessage(String messageId) async {
    try {
      await FirebaseFirestore.instance.collection('chat').doc(messageId).delete();
    } catch (error) {
      // Handle error
      // ignore: avoid_print
      print('Error deleting comment: $error');
    }
  }

  // Function to update a message
  Future<void> _updateMessage(String messageId, String newText) async {
    try {
      await FirebaseFirestore.instance.collection('chat').doc(messageId).update({
        'text': newText,
        'updatedAt': Timestamp.now(),
      });
    } catch (error) {
      // Handle error
      // ignore: avoid_print
      print('Error updating comment: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(color: Colors.grey.shade300, width: 1.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(widget.userImage), // User image
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.username,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.time.toDate().toString(), // Convert timestamp to readable date
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                // Edit button/icon
                if (widget.isMe)
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      _editController.text = widget.text;
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Edit comment'),
                            content: TextField(
                              controller: _editController,
                              maxLines: null,
                              decoration: const InputDecoration(
                                hintText: 'Edit your comment...',
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  _updateMessage(widget.messageId, _editController.text); // Call update function
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Save'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                // Delete button/icon
                if (widget.isMe)
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Delete Message'),
                            content: const Text('Are you sure you want to delete this message?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  _deleteMessage(widget.messageId); // Call delete function
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
              ],
            ),
            const SizedBox(height: 8.0),
            MessageBubble(
              message: widget.text,
              isMe: widget.isMe,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _editController.dispose();
    super.dispose();
  }
}

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;

  // ignore: use_super_parameters
  const MessageBubble({
    required this.message,
    required this.isMe,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isMe ? 12 : 0),
          topRight: Radius.circular(isMe ? 0 : 12),
          bottomLeft: const Radius.circular(12),
          bottomRight: const Radius.circular(12),
        ),
      ),
      padding: const EdgeInsets.all(8),
      child: Text(
        message,
        style: TextStyle(
          color: isMe ? Colors.black : Colors.black,
        ),
      ),
    );
  }
}
