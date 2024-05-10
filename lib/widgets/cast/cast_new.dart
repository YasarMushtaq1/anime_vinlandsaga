import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../user_image_picker.dart';

class CastNew extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const CastNew({Key? key});

  @override
  State<CastNew> createState() => _CastNewState();
}

class _CastNewState extends State<CastNew> {
  // ignore: prefer_final_fields
  var _messageController = TextEditingController();
  File? _actorImage;
  File? _rolePlayerImage;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _submitMessage() async {
    final enteredMessage = _messageController.text;
    if (enteredMessage.trim().isEmpty || _actorImage == null || _rolePlayerImage == null) {
      // Check if any required field is empty
      return;
    }
    FocusScope.of(context).unfocus();
    _messageController.clear();

    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    String actorImageUrl = '';
    String rolePlayerImageUrl = '';

    // Uploading actor image
    // ignore: prefer_interpolation_to_compose_strings
    final actorImageRef = FirebaseStorage.instance.ref().child('cast_images').child(user.uid + '_actor.jpg');
    await actorImageRef.putFile(_actorImage!);
    actorImageUrl = await actorImageRef.getDownloadURL();

    // Uploading role player image
    // ignore: prefer_interpolation_to_compose_strings
    final rolePlayerImageRef = FirebaseStorage.instance.ref().child('cast_images').child(user.uid + '_role_player.jpg');
    await rolePlayerImageRef.putFile(_rolePlayerImage!);
    rolePlayerImageUrl = await rolePlayerImageRef.getDownloadURL();

    FirebaseFirestore.instance.collection('cast').add({
      'text': enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData['username'],
      'userImage': userData['image_url'],
      'actorImage': actorImageUrl,
      'rolePlayerImage': rolePlayerImageUrl,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _messageController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              decoration: const InputDecoration(
                hintText: 'Description',
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.transparent,
                contentPadding: EdgeInsets.all(10),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Column(
                                children: [
                                  UserImagePicker(
                                    onPickImage: (pickedImage) {
                                      setState(() {
                                        _actorImage = pickedImage;
                                      });
                                    },
                                    label: 'Select Actor Image',
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    child: Text(
                                      'Actor Image',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Column(
                                children: [
                                  UserImagePicker(
                                    onPickImage: (pickedImage) {
                                      setState(() {
                                        _rolePlayerImage = pickedImage;
                                      });
                                    },
                                    label: 'Select Role Player Image',
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    child: Text(
                                      'Role Player Image',
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _submitMessage,
              // ignore: sort_child_properties_last
              child: const Text('Post Cast'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(255, 211, 113, 0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
