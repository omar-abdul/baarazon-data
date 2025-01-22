import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqliteDb {
  Database? _database;

  Future<Database> get database async {
    _database ??= await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'baarazon.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Create tables
        await db.execute('''
          CREATE TABLE sync_info (
            table_name TEXT PRIMARY KEY,
            last_sync TIMESTAMP NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE providers (
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL,
            available INTEGER NOT NULL DEFAULT 0,
            image_path TEXT NOT NULL,
            display_name TEXT NOT NULL,
            show_in_app INTEGER NOT NULL DEFAULT 1,
            region TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE services (
            id INTEGER PRIMARY KEY,
            provider_id INTEGER NOT NULL,
            name TEXT NOT NULL,
            cost_price DECIMAL(10,2) NOT NULL,
            advertised_price DECIMAL(10,2) NOT NULL,
            description TEXT NOT NULL,
            type TEXT NOT NULL,
            currency TEXT NOT NULL,
            FOREIGN KEY (provider_id) REFERENCES providers (id) ON DELETE CASCADE
          )
        ''');
      },
    );
  }

  Future<String?> getLastSync(String tableName) async {
    final db = await database;
    final result = await db.query(
      'sync_info',
      where: 'table_name = ?',
      whereArgs: [tableName],
    );

    if (result.isEmpty) return null;
    return result.first['last_sync'] as String;
  }

  Future<void> updateLastSync(String tableName) async {
    final db = await database;
    await db.insert(
      'sync_info',
      {
        'table_name': tableName,
        'last_sync': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> insert(String table, Map<String, dynamic> values) async {
    final db = await database;
    return await db.insert(table, values);
  }

  Future<List<Map<String, dynamic>>> query(String table,
      {String? where, List<dynamic>? whereArgs}) async {
    final db = await database;
    return await db.query(table, where: where, whereArgs: whereArgs);
  }
}
