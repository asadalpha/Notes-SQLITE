import 'package:flutter/material.dart';
import 'package:my_notes/pages/create_note.dart';
import 'package:my_notes/pages/expanded_item_page.dart';


class HomePage extends StatelessWidget {
  // Example list of notes
  final List<Map<String, String>> notes = [
    {
      "title": "Meeting Notes",
      "image": "https://images.pexels.com/photos/27668991/pexels-photo-27668991/free-photo-of-a-stack-of-books-on-a-shelf-with-a-white-wall.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1", // Example image URL
      "description": "my note 1 abcd lorem ipsum for everyone"
    },
    {
      "title": "Shopping List",
      "image": "", // No image available
      "description": "Buy milk, bread, and eggs."
    },
    {
      "title": "To-Do",
      "image": "https://images.pexels.com/photos/4145190/pexels-photo-4145190.jpeg?auto=compress&cs=tinysrgb&w=600", // Example image URL
      "description": "my note 1 abcd lorem ipsum for everyone"
    },
    {
      "title": "Books to Read",
      "image": "", // No image available
      "description": "Finish reading Flutter docs"
    },
  ];

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateNotePage()));},backgroundColor: Color.fromARGB(255, 48, 48, 48), child: Icon(Icons.add,color: Colors.white,),),
     
      appBar: AppBar(
        
        title: const Text(
          'Notes',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_horiz_rounded, color: Colors.white),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of items per row
            crossAxisSpacing: 8.0, // Spacing between columns
            mainAxisSpacing: 8.0, // Spacing between rows
          ),
          itemCount: notes.length,
          itemBuilder: (context, index) {
            return NoteCard(
              title: notes[index]["title"]!,
              description: notes[index]['description']!,
              imageUrl: notes[index]["image"]!,
              onTap: () {
                // Navigate to detail page when tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NoteDetailPage(
                      title: notes[index]["title"]!,
                      description: notes[index]["description"]!,
                      imageUrl: notes[index]["image"]!,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class NoteCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
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
    return InkWell(
      onTap: onTap,
      child: Card(
       
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color.fromARGB(255, 116, 112, 112), width: 1.0),
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
                  ? Image.network(
                      imageUrl,
                      height: 100.0, // Adjust as per your requirement
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
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
}