import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DataBaseHelper {
  static DataBaseHelper dataBaseHelper = DataBaseHelper._singleton();

  DataBaseHelper._singleton();

  Database? _database;

  Future get database async => _database ?? await initDatabase();

  Future initDatabase() async {
    final path = await getDatabasesPath();
    final dbPath = join(path, 'budgetTracker.db');

    _database = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        String sql = '''CREATE TABLE budget(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      amount REAL NOT NULL,
      isIncome INTEGER NOT NULL,
      category TEXT
      );
      ''';
        await db.execute(sql);
      },
    );
    return _database;
  }

  Future insertData(double amount, int isIncome, String category) async {
    Database? db = await database;
    String sql =
    '''INSERT INTO budget (amount,isIncome,category) VALUES (?,?,?)''';
    List args = [amount, isIncome, category];
    await db!.rawInsert(sql, args);
  }

  Future readData() async {
    Database? db = await database;
    String sql = '''SELECT * FROM budget''';
    return await db!.rawQuery(sql);
  }

  Future deleteData(int id) async {
    Database? db = await database;
    String sql = '''DELETE FROM budget WHERE id = ?''';
    List args = [id];
    await db!.rawDelete(sql, args);
  }
}
