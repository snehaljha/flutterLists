import 'dart:io';

import 'package:lists/dbs/table_names.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

// ignore: camel_case_types
class mainDBProvider {
  mainDBProvider._();

  static final mainDBProvider db = mainDBProvider._();
  static Database _database;

  Future<Database> get database async {
    if (_database == null) _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory docsdir = await getApplicationDocumentsDirectory();
    String path = join(docsdir.path, 'table_names.db');
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE table_names (name TEXT PRIMARY KEY)');
    });
  }

  Future<List<table_names>> getAllNames() async {
    final db = await database;
    List<Map> results =
        await db.query("table_names", columns: ['name'], orderBy: 'name ASC');

    List<table_names> tnames = List();
    results.forEach((result) {
      table_names table = table_names.fromMap(result);
      tnames.add(table);
    });
    return tnames;
  }

  Future<bool> isPresent(String str) async {
    final db = await database;
    var result =
        await db.query('table_names', where: 'name = ', whereArgs: [str]);
    // ignore: unrelated_type_equality_checks
    return result != Null;
  }

  insert(table_names table) async {
    final db = await database;
    await db.insert('table_names', table.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  delete(String str) async {
    final db = await database;
    await db.rawDelete('DELETE FROM table_names WHERE name = ?', [str]);
  }

  finish() async {
    final db = await database;
    await db.close();
  }
}
