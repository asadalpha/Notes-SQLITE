class Note {
  final int? id;
  final String title;
  final String note;
  final String? imagePath;

  Note({
    this.id,
    required this.title,
    required this.note,
    this.imagePath,
  });

  // Convert a Note into a Map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'note': note,
      'imagePath': imagePath,
    };
  }

  // Convert a Map into a Note.
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      note: map['note'],
      imagePath: map['imagePath'],
    );
  }

  // The copyWith method to clone a Note with optional changes
  Note copyWith({
    int? id,
    String? title,
    String? note,
    String? imagePath,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      note: note ?? this.note,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
