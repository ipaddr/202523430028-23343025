class DatabaseNote {
  final int id;
  final String text;
  final String userId;

  DatabaseNote({
    required this.id,
    required this.text,
    required this.userId,
  });

  DatabaseNote.fromRow(Map<String, Object?> map)
      : id = map['id'] as int,
        text = map['text'] as String,
        userId = map['user_id'] as String;

  @override
  String toString() => 'Note, id = $id, userId = $userId, text = $text';

  @override
  bool operator ==(covariant DatabaseNote other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
