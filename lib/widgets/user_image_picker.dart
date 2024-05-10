import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, required this.onPickImage, required String label});

  final void Function(File pickedImage) onPickImage;

  @override
  State<UserImagePicker> createState() {
    return _UserImagePickerState();
  }
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImageFile;
  bool _fileUploaded = false;

  void _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );
    if (pickedImage == null) {
      return;
    }
    setState(() {
      _pickedImageFile = File(pickedImage.path);
      _fileUploaded = true;
    });

    widget.onPickImage(_pickedImageFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton.icon(
          onPressed: _pickImage,
          icon: _fileUploaded
              ? const Icon(Icons.check_circle, color: Colors.green) // Change icon to check_circle if file uploaded
              : const Icon(Icons.attach_file), // Change icon to attach_file if no file uploaded
          label: Text(
            _fileUploaded ? 'File Uploaded' : 'Attach Image', // Change text based on file upload status
            style: TextStyle(
              color: _fileUploaded ? Colors.green : Theme.of(context).colorScheme.primary, // Change text color based on file upload status
            ),
          ),
        ),
      ],
    );
  }
}
