import 'dart:io';
import 'package:flutter/material.dart';

class NoteCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl; // Path or URL of the image
  final VoidCallback onTap;

  const NoteCard({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    // Calculate responsive dimensions
    final imageWidth = screenWidth * 0.4; // 40% of screen width
    final imageHeight = screenHeight * 0.14; // 20% of screen height

    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
              color: Color.fromARGB(255, 116, 112, 112), width: 1.0),
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 8.0),
              imageUrl.isNotEmpty
                  ? _buildImage(imageUrl, imageWidth, imageHeight)
                  : Expanded(
                      child: Text(
                        description,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14.0,
                        ),
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  // This function checks whether the image path is a file or a URL
  Widget _buildImage(String imageUrl, double width, double height) {
    try {
      if (Uri.tryParse(imageUrl)?.isAbsolute == true) {
        // If the image path is a URL, load it from the web
        return Center(
          child: Image.network(
            imageUrl,
            width: width,
            height: height,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Text(
                'Image not found',
                style: TextStyle(color: Colors.red),
              );
            },
          ),
        );
      } else {
        // Otherwise, load the image from the local file system
        return Center(
          child: Image.file(
            File(imageUrl),
            width: width,
            height: height,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Text(
                'Image not found',
                style: TextStyle(color: Colors.red),
              );
            },
          ),
        );
      }
    } catch (e) {
      return const Text(
        'Image not found',
        style: TextStyle(color: Colors.red),
      );
    }
  }
}
