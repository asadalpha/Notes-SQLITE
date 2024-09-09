import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'notes.dart';

class NoteRepository {
  static final NoteRepository _instance = NoteRepository._internal();
  static Database? _database;

  factory NoteRepository() {
    return _instance;
  }

  NoteRepository._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    // If the database is null, initialize it
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'notes.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE notes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            note TEXT,
            imagePath TEXT
          )
        ''');
      },
      onOpen: (db) {
        print('Database opened');
      },
      onUpgrade: (db, oldVersion, newVersion) {
        print('Database upgraded from version $oldVersion to $newVersion');
      },
    );
  }

  Future<int> insertNote(Note note) async {
    try {
      final db = await database;
      return await db.insert(
        'notes',
        note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Error inserting note: $e');
      rethrow;
    }
  }

  Future<List<Note>> getNotes() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query('notes');
      return List.generate(maps.length, (i) {
        return Note.fromMap(maps[i]);
      });
    } catch (e) {
      print('Error fetching notes: $e');
      rethrow;
    }
  }

  Future<int> updateNote(Note note) async {
    try {
      final db = await database;
      return await db.update(
        'notes',
        note.toMap(),
        where: 'id = ?',
        whereArgs: [note.id],
      );
    } catch (e) {
      print('Error updating note: $e');
      rethrow;
    }
  }

  Future<int> deleteNote(int id) async {
    try {
      final db = await database;
      return await db.delete(
        'notes',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('Error deleting note: $e');
      rethrow;
    }
  }
}
