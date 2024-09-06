import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class CreateNotePage extends StatefulWidget {
  const CreateNotePage({super.key});

  @override
  _CreateNotePageState createState() => _CreateNotePageState();
}

class _CreateNotePageState extends State<CreateNotePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  File? _image;

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios)),
        actions: [
          IconButton(
              onPressed: () {
                _pickImage(); // Corrected to call the function
              },
              icon: const Icon(Icons.add_card))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title field
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                  hintText: 'Title',
                  hintStyle: TextStyle(fontSize: 22, color: Colors.grey),
                  border: InputBorder.none,
                  hintMaxLines: 1),
            ),
            const SizedBox(height: 2),

            // Note field
            TextField(
              controller: _noteController,
              maxLines: 10,
              decoration: const InputDecoration(
                  hintText: 'Note',
                  hintStyle: TextStyle(fontSize: 18, color: Colors.grey),
                  border: InputBorder.none),
            ),
            const SizedBox(height: 16),

            // Button to pick image
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (_image != null)
                  Image.file(
                    _image!,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
              ],
            ),

            const Spacer(),

            // Save button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle saving logic here
                  String title = _titleController.text;
                  String note = _noteController.text;
                  // You can also save the image and other data as needed
                  print('Title: $title, Note: $note, Image: $_image');
                },
                child: const Text('Save Note'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
