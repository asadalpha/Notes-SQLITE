import 'package:flutter/material.dart';

class NoteDetailPage extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;

  const NoteDetailPage({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   
      appBar: AppBar(
       
       
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    width: double.infinity,
                    height: 250.0,
                    fit: BoxFit.cover,
                  )
                : Container(),
            const SizedBox(height: 16.0),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              description,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}