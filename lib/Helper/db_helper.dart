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
        category TEXT,
        img TEXT
        )
        ''';
        db.execute(sql);
      },
    );
  }

  Future<int> insertData(
      double amount, int isIncome, String category, String img) async {
    final db = await database;
    String sql = '''
    INSERT INTO $tableName (amount, isIncome, category, img)
    VALUES (?,?,?,?);
    ''';
    List args = [amount, isIncome, category, img];
    return await db!.rawInsert(sql, args);
  }

  Future<List<Map<String, Object?>>> readData() async {
    final db = await database;
    String sql = '''
    SELECT * FROM $tableName
    ''';
    return await db!.rawQuery(sql);
  }

  Future<List<Map<String, Object?>>> readDataBySearch(String search) async {
    final db = await database;
    String sql = '''
    SELECT * FROM $tableName WHERE category LIKE '$search%'
    ''';
    return await db!.rawQuery(sql);
  }

  Future<List<Map<String, Object?>>> readCategoryData(int isIncome) async {
    final db = await database;
    String sql = '''
    SELECT * FROM $tableName WHERE isIncome = ?
    ''';
    List args = [isIncome];
    return await db!.rawQuery(sql, args);
  }

  Future<int> updateData(
      int id, double amount, int isIncome, String category, String img) async {
    final db = await database;
    String sql = '''
    UPDATE $tableName SET amount = ?, isIncome = ?, category = ?, img = ? WHERE id = ?
    ''';
    List args = [amount, isIncome, category, img, id];
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
