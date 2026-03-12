import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;
import 'database_note.dart';
import 'auth_service.dart';

class NotesService {
  Database? _db;

  static final NotesService _shared = NotesService._sharedInstance();
  NotesService._sharedInstance();
  factory NotesService() => _shared;

  Future<DatabaseNote> createNote({required String text, required AuthUser owner}) async {
    final db = _getDatabaseOrThrow();
    final userId = owner.uid;

    final noteId = await db.insert('note', {
      'text': text,
      'user_id': userId,
    });

    return DatabaseNote(
      id: noteId,
      text: text,
      userId: userId,
    );
  }

  Future<Iterable<DatabaseNote>> getAllNotes() async {
    final db = _getDatabaseOrThrow();
    final notes = await db.query('note');
    return notes.map((noteRow) => DatabaseNote.fromRow(noteRow));
  }

  Future<DatabaseNote> updateNote({
    required DatabaseNote note,
    required String text,
  }) async {
    final db = _getDatabaseOrThrow();
    final updatesCount = await db.update(
      'note',
      {'text': text},
      where: 'id = ?',
      whereArgs: [note.id],
    );

    if (updatesCount == 0) {
      throw Exception('Could not update note');
    } else {
      return DatabaseNote(
        id: note.id,
        text: text,
        userId: note.userId,
      );
    }
  }

  Future<void> deleteNote({required int id}) async {
    final db = _getDatabaseOrThrow();
    final deleteCount = await db.delete(
      'note',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (deleteCount == 0) {
      throw Exception('Could not delete note');
    }
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw Exception('Database not open');
    }
    return db;
  }

  Future<void> open() async {
    if (_db != null) return;

    final docsPath = await getApplicationDocumentsDirectory();
    final dbPath = join(docsPath.path, 'notes.db');
    final db = await openDatabase(dbPath);
    _db = db;

    // create the note table
    await db.execute('''CREATE TABLE IF NOT EXISTS "note" (
      "id" INTEGER PRIMARY KEY AUTOINCREMENT,
      "text" TEXT,
      "user_id" TEXT
    );''');
  }
}
