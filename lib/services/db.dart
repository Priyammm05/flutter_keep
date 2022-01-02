import 'package:flutter_keep/models/note_model.dart';
import 'package:flutter_keep/services/firestore_db.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class NotesDb {
  static final NotesDb instance = NotesDb._init();
  static Database? _database;
  NotesDb._init();

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await _initializeDB('NewNotes.db');
    return _database;
  }

  Future<Database> _initializeDB(String filepath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filepath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const boolType = 'BOOLEAN NOT NULL';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
      CREATE TABLE Notes(
        ${NotesVariable.id} $idType,
        ${NotesVariable.uniqueID} $textType,
        ${NotesVariable.pin} $boolType,
        ${NotesVariable.isArchive} $boolType,
        ${NotesVariable.title} $textType,
        ${NotesVariable.content} $textType,
        ${NotesVariable.createdTime} $textType
      )
    ''');
  }

  Future<Note?> create(Note note) async {
    final db = await instance.database;
    final id = await db!.insert(NotesVariable.table, note.toJson());
    await FireDB().createNewNoteFirestore(note);
    return note.copy(id: id);
  }

  Future<List<Note>> readNotes() async {
    final db = await instance.database;
    const orderBy = '${NotesVariable.createdTime} ASC';
    final queryResult = await db!.query(NotesVariable.table, orderBy: orderBy);
    return queryResult.map((json) => Note.fromJson(json)).toList();
  }

  Future<List<Note>> readArchive() async {
    final db = await instance.database;
    const orderBy = '${NotesVariable.createdTime} ASC';
    final queryResult = await db!.query(
      NotesVariable.table,
      orderBy: orderBy,
      where: '${NotesVariable.isArchive} = 1',
    );
    return queryResult.map((json) => Note.fromJson(json)).toList();
  }

  Future<Note?> readOneNote(int id) async {
    final db = await instance.database;
    final map = await db!.query(
      NotesVariable.table,
      columns: NotesVariable.values,
      where: '${NotesVariable.id} = ?',
      whereArgs: [id],
    );
    if (map.isNotEmpty) {
      return Note.fromJson(map.first);
    } else {
      return null;
    }
  }

  Future updateNote(Note note) async {
    await FireDB().updateNoteFirestore(note);
    final db = await instance.database;
    await db!.update(
      NotesVariable.table,
      note.toJson(),
      where: '${NotesVariable.id} = ?',
      whereArgs: [note.id],
    );
  }

  Future pinNote(Note? note) async {
    final db = await instance.database;
    await db!.update(
      NotesVariable.table,
      {NotesVariable.pin: !note!.pin ? 1 : 0},
      where: '${NotesVariable.id} = ?',
      whereArgs: [note.id],
    );
  }

  Future archiveNote(Note? note) async {
    final db = await instance.database;
    await db!.update(
      NotesVariable.table,
      {NotesVariable.isArchive: !note!.isArchive ? 1 : 0},
      where: '${NotesVariable.id} = ?',
      whereArgs: [note.id],
    );
  }

  Future delteNote(Note note) async {
    await FireDB().deleteNoteFirestore(note);
    final db = await instance.database;
    await db!.delete(
      NotesVariable.table,
      where: '${NotesVariable.id}= ?',
      whereArgs: [note.id],
    );
  }

  Future closeDB() async {
    final db = await instance.database;
    db!.close();
  }

  Future<List<int>> getNoteString(String query) async {
    final db = await instance.database;
    final result = await db!.query(NotesVariable.table);
    List<int> resultIds = [];
    // ignore: avoid_function_literals_in_foreach_calls
    result.forEach((element) {
      if (element["title"].toString().toLowerCase().contains(query) ||
          element["content"].toString().toLowerCase().contains(query)) {
        resultIds.add(element["id"] as int);
      }
    });

    return resultIds;
  }
}
