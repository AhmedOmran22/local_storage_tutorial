import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteService {
  static Database? _database;

  /// Singleton instance
  static Future<Database> get database async {
    _database ??= await _initDatabase("app.db");
    return _database!;
  }

  /// Initialize DB
  static Future<Database> _initDatabase(String dbName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE posts(
        id TEXT PRIMARY KEY,
        username TEXT NOT NULL,
        userImage TEXT NOT NULL,
        imageUrl TEXT NOT NULL,
        caption TEXT NOT NULL,
        likes INTEGER NOT NULL
      )
    ''');
  }

  // ================================
  // 🟢 CREATE
  // ================================
  Future<int> insert({
    required String table,
    required Map<String, dynamic> data,
  }) async {
    final db = await database;
    return await db.insert(table, data);
  }

  // ================================
  // 🔵 READ (Get All)
  // ================================
  Future<List<Map<String, dynamic>>> getAll({required String table}) async {
    final db = await database;
    return await db.query(table);
  }

  // ================================
  // 🔵 READ (By ID)
  // ================================
  Future<Map<String, dynamic>?> getById({
    required String table,
    required int id,
  }) async {
    final db = await database;

    final result = await db.query(table, where: 'id = ?', whereArgs: [id]);

    return result.isNotEmpty ? result.first : null;
  }

  // ================================
  // 🟡 UPDATE
  // ================================
  Future<int> update({
    required String table,
    required int id,
    required Map<String, dynamic> data,
  }) async {
    final db = await database;

    return await db.update(table, data, where: 'id = ?', whereArgs: [id]);
  }

  // ================================
  // 🔴 DELETE
  // ================================
  Future<int> delete({required String table, required int id}) async {
    final db = await database;

    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  // ================================
  // 🧹 DELETE ALL
  // ================================
  Future<int> deleteAll({required String table}) async {
    final db = await database;
    return await db.delete(table);
  }

  // ================================
  // ❌ CLOSE DATABASE
  // ================================
  Future<void> close({required String table}) async {
    final db = await database;
    return db.close();
  }
}
