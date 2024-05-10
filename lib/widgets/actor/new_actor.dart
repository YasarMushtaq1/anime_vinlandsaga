import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../user_image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class NewActor extends StatefulWidget {
  // ignore: use_super_parameters
  const NewActor({Key? key}) : super(key: key);

  @override
  State<NewActor> createState() => _NewActorState();
}

class _NewActorState extends State<NewActor> {
  late TextEditingController _messageController;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
  }

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
    final userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    String imageUrl = '';

    if (_selectedImage != null) {
      // ignore: prefer_interpolation_to_compose_strings
      final ref = FirebaseStorage.instance.ref().child('news_images').child(user.uid + DateTime.now().toString() + '.jpg');
      await ref.putFile(_selectedImage!);
      imageUrl = await ref.getDownloadURL();
    }

    FirebaseFirestore.instance.collection('actor').add({
      'text': enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData['username'],
      'userImage': userData['image_url'],
      'image': imageUrl,
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
                hintText: 'Whos is new actor?',
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
                  child: UserImagePicker(
                    onPickImage: (pickedImage) {
                      setState(() {
                        _selectedImage = pickedImage;
                      });
                    },
                    label: 'Picture',
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _submitMessage,
                  // ignore: sort_child_properties_last
                  child: const Text('Post Actor'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 211, 113, 0),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
