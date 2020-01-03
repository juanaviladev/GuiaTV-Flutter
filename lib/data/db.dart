import 'dart:io';
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbConnection {

  DbConnection._();

  static final DbConnection instance = DbConnection._();

  Database _conn;

  Future<Database> get db async {
    if (_conn != null)
      return _conn;

    // if _database is null we instantiate it
    _conn = await initDB();
    return _conn;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "tv_guide.db");
    return await openDatabase(
        path, version: 1,
        onOpen: (db) {

        },
        onCreate: (Database db, int version) async {
          await db.execute('''CREATE TABLE program (
            id TEXT PRIMARY KEY,
            img_url TEXT,
            title TEXT,
            genre TEXT,
            ini_time TEXT,
            end_time TEXT,
            date TEXT);
          ''');
    });
  }
}


