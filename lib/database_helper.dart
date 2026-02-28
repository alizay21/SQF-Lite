import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;
  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'todo_manager.db');
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      )''');

    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        categoryId INTEGER,
        isDone INTEGER NOT NULL,
        FOREIGN KEY (categoryId) REFERENCES categories (id) ON DELETE CASCADE
      )''');

    // Default categories
    await db.insert('categories', {'name': 'Work'});
    await db.insert('categories', {'name': 'Personal'});
  }

  // Category CRUD
  Future<int> addCategory(CategoryModel category) async =>
      (await database).insert('categories', category.toJson());

  Future<List<CategoryModel>> getCategories() async {
    final res = await (await database).query('categories');
    return res.map((json) => CategoryModel.fromJson(json)).toList();
  }

  Future<int> deleteCategory(int id) async =>
      (await database).delete('categories', where: 'id = ?', whereArgs: [id]);

  // Task CRUD
  Future<int> addTask(TaskModel task) async =>
      (await database).insert('tasks', task.toJson());

  Future<List<TaskModel>> getTasks() async {
    final db = await database;
    final res = await db.rawQuery('''
      SELECT tasks.*, categories.name as categoryName 
      FROM tasks 
      JOIN categories ON tasks.categoryId = categories.id
    ''');
    return res.map((json) => TaskModel.fromJson(json)).toList();
  }

  Future<int> updateTask(TaskModel task) async => (await database)
      .update('tasks', task.toJson(), where: 'id = ?', whereArgs: [task.id]);

  Future<int> deleteTask(int id) async =>
      (await database).delete('tasks', where: 'id = ?', whereArgs: [id]);
}