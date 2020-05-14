import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DataBaseHelper {
  String databaseName = "database.db";

  static Database db;

  Future<Database> get database async {
    if (db != null) return db;
    db = await initDatabase();
    return db;
  }

  initDatabase() async {
    String path = await initDatabasePath(databaseName);
    var database = await openDatabase(path, version: 1, onCreate: createTable);
    return database;
  }

  Future<String> initDatabasePath(String databaseName) async {
    Directory databasePath = await getExternalStorageDirectory();
    String path = join(databasePath.path, databaseName);
    if (await new Directory(dirname(path)).exists())
      await deleteDatabase(path);
    else
      await new Directory(dirname(path)).create(recursive: true);
    return path;
  }

  void createTable(Database database, int version) async {
    //ex: await database.execute(query);
  }

  Future<int> insert(String query) async {
    final Database db = await database;
    var response = db.rawInsert(query);
    await db.close();
    return response;
  }

  Future<List<Map<String, dynamic>>> select(String query) async {
    final Database db = await database;
    var response = db.rawQuery(query);
    await db.close();
    return response;
  }

  Future<int> update(String query) async {
    final Database db = await database;
    var response = db.rawUpdate(query);
    await db.close();
    return response;
  }

  delete(String query) async {
    final db = await database;
    db.rawDelete(query);
    await db.close();
  }
}
