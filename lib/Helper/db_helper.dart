
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper databaseHelper = DatabaseHelper._();

  DatabaseHelper._();

  static const String databaseName = 'finance.db';
  static const String tableName = 'finance';

  Database? _database;

  Future<Database?> get database async => _database ?? await initDatabase();

  Future<Database?> initDatabase() async {
    final path = await getDatabasesPath();
    final dbPath = join(path, databaseName);
    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        String sql = '''
        CREATE TABLE $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount REAL NOT NULL,
        isIncome INTEGER NOT NULL,
        category TEXT
        )
        ''';
        db.execute(sql);
      },
    );
  }

  Future<int> insertData(double amount, int isIncome, String category) async {
    final db = await database;
    String sql = '''
    INSERT INTO $tableName (amount, isIncome, category)
    VALUES (?,?,?);
    ''';
    List args = [amount, isIncome, category];
    return await db!.rawInsert(sql, args);
  }

  Future<List<Map<String, Object?>>> readData() async {
    final db = await database;
    String sql = '''
    SELECT * FROM $tableName
    ''';
    return await db!.rawQuery(sql);
  }

  Future<int> updateData(
      int id, double amount, int isIncome, String category) async {
    final db = await database;
    String sql = '''
    UPDATE $tableName SET amount = ?, isIncome = ?, category = ? WHERE id = ?
    ''';
    List args = [amount, isIncome, category, id];
    return await db!.rawUpdate(sql, args);
  }

  Future<int> deleteData(int id) async {
    final db = await database;
    String sql = '''
    DELETE FROM $tableName WHERE id = ?
    ''';
    List args = [id];
    return await db!.rawDelete(sql, args);
  }
}
