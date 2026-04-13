import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (kIsWeb) {
      throw UnsupportedError("SQLite não funciona no Web");
    }

    if (_database != null) return _database!;
    _database = await _initDB('dados.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE dados (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT,
        descricao TEXT,
        data TEXT
      )
    ''');
  }

  // CREATE
  Future<int> insert(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('dados', row);
  }

  // READ
  Future<List<Map<String, dynamic>>> getAll() async {
    final db = await instance.database;
    return await db.query('dados', orderBy: "titulo ASC");
  }

  // UPDATE
  Future<int> update(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.update(
      'dados',
      row,
      where: 'id = ?',
      whereArgs: [row['id']],
    );
  }

  // DELETE
  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      'dados',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}