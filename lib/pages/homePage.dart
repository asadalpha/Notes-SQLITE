import 'package:flutter/material.dart';
import 'package:my_notes/components/note_card.dart';
import 'package:my_notes/model/node_repo.dart';
import 'package:my_notes/model/notes.dart';
import 'package:my_notes/pages/handle_notes.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late NoteRepository _noteRepository;
  late Future<List<Note>> _noteListFuture;

  @override
  void initState() {
    _noteRepository = NoteRepository();
    _noteListFuture = _noteRepository.getNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
                  MaterialPageRoute(builder: (context) => const HandleNotes()))
              .then((_) {
            setState(() {
              _noteListFuture = _noteRepository.getNotes();
            });
          });
        },
        backgroundColor: const Color.fromARGB(255, 48, 48, 48),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        title: const Text(
          'Notes',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
        
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_horiz_rounded, color: Colors.white),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<Note>>(
          future: _noteListFuture,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (snapshot.hasData) {
              final notes = snapshot.data!;
              if (notes.isEmpty) {
                return const Center(
                  child: Text("Sooo Empty"),
                );
              }
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of items per row
                  crossAxisSpacing: 8.0, // Spacing between columns
                  mainAxisSpacing: 8.0, // Spacing between rows
                ),
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index]; // Fetch the current note
                  return NoteCard(
                    title: note.title,
                    description: note.note,
                    imageUrl: note.imagePath ?? '',
                    onTap: () {
                      // Navigate to HandleNotes with the selected note for editing
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HandleNotes(note: note),
                        ),
                      ).then((_) {
                        setState(() {
                          _noteListFuture = _noteRepository
                              .getNotes(); // Refresh after editing
                        });
                      });
                    },
                  );
                },
              );
            } else {
              return const Center(child: Text('No notes found.'));
            }
          },
        ),
      ),
    );
  }
}
