import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TodoDbHelper {
  static const _dbName = 'todo_v2.db';
  static const _dbVersion = 3;
  static const tableTodos = 'todos';
  static const colId = 'id';
  static const colTitle = 'title';
  static const colDescription = 'description';
  static const colIsCompleted = 'is_completed';
  static const colCreatedAt = 'created_at';
  static const colPriority = 'priority';
  static const colDueDate = 'due_date';

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE $tableTodos(
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
      $colTitle TEXT NOT NULL,
      $colDescription TEXT,
      $colIsCompleted INTEGER NOT NULL,
      $colCreatedAt TEXT NOT NULL,
      $colPriority INTEGER NOT NULL,
      $colDueDate TEXT)
                    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      await db.execute(
        "ALTER TABLE todos ADD COLUMN priority INTEGER NOT NULL DEFAULT 1",
      );
      await db.execute("ALTER TABLE todos ADD COLUMN due_date TEXT");
    }
  }
}
