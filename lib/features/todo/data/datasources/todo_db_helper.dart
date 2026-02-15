import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TodoDbHelper {
  static const _dbName = 'todo_v2.db';
  static const _dbVersion = 2;
  static const tableTodos = 'todos';
  static const colId = 'id';
  static const colTitle = 'title';
  static const colDescription = 'description';
  static const colIsCompleted = 'is_completed';
  static const colCreatedAt = 'created_at';

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    return openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE $tableTodos(
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
      $colTitle TEXT NOT NULL,
      $colDescription TEXT,
      $colIsCompleted INTEGER NOT NULL,
      $colCreatedAt TEXT NOT NULL
  )
  ''');
  }
}
