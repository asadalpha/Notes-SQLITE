import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:my_notes/model/node_repo.dart'; // Your note repository file
import 'package:my_notes/model/notes.dart'; // Your note model

class HandleNotes extends StatefulWidget {
  final Note? note; // Accept an optional Note object for editing

  const HandleNotes({super.key, this.note}); // Constructor

  @override
  _HandleNotesState createState() => _HandleNotesState();
}

class _HandleNotesState extends State<HandleNotes> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  File? _image;
  final NoteRepository _noteRepository = NoteRepository();

  @override
  void initState() {
    super.initState();

    // If editing an existing note, initialize the fields
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _noteController.text = widget.note!.note;
      if (widget.note!.imagePath != null &&
          widget.note!.imagePath!.isNotEmpty) {
        _image = File(widget.note!.imagePath!);
      }
    }
  }

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

  // Function to save or update the note
  Future<void> _saveOrUpdateNote() async {
    String title = _titleController.text;
    String note = _noteController.text;
    String? imagePath = _image?.path;

    if (title.isNotEmpty && note.isNotEmpty) {
      if (widget.note == null) {
        // Creating a new note
        Note newNote = Note(title: title, note: note, imagePath: imagePath);
        await _noteRepository.insertNote(newNote);
      } else {
        // Updating an existing note
        Note updatedNote = widget.note!.copyWith(
          title: title,
          note: note,
          imagePath: imagePath,
        );
        await _noteRepository.updateNote(updatedNote);
      }
      Navigator.of(context).pop();
    } else {
      // Show an error message
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Please fill in all fields'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios)),
        actions: [
          IconButton(
              onPressed: () {
                _pickImage();
              },
              icon: Icon(Icons.image)),
          IconButton(
              onPressed: () {
                _saveOrUpdateNote();
              },
              icon: const Icon(
                Icons.check_rounded,
                size: 28,
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title field
            TextField(
              style: const TextStyle(fontSize: 22),
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

            // Display the image with correct sizing
            if (_image != null)
              Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height *
                      0.4, // Max height for image is 40% of screen height
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.file(
                    _image!,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}
