import 'dart:io';

import 'package:lists/dbs/table_names.dart';
import 'package:lists/dbs/tasks.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

// ignore: camel_case_types
class taskDBProvider {
  taskDBProvider._();
  // ignore: non_constant_identifier_names
  String list_name; // with s

  static final taskDBProvider db = taskDBProvider._();
  static Database _database;

  Future<Database> get database async {
    if (_database == null) _database = await initDB();
    return _database;
  }

  void setName(String str) {
    list_name = str;
  }

  initDB() async {
    Directory docsdir = await getApplicationDocumentsDirectory();
    String path = join(docsdir.path, list_name + '.db');
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE "' +
          list_name +
          '" (task TEXT PRIMARY KEY, strike INTEGER)');
    });
  }

  Future<List<Tasks>> getAllNames() async {
    final db = await database;
    List<Map> results = await db.rawQuery('SELECT * FROM "' + list_name + '"');
    List<Tasks> tnames = List();
    results.forEach((result) {
      Tasks task = Tasks.fromMap(result);
      tnames.add(task);
    });
    return tnames;
  }

  // Future<bool> isPresent(String str) async {
  //   final db = await database;
  //   var result =
  //       await db.query('table_names', where: 'name = ', whereArgs: [str]);
  //   return result != Null;
  // }

  insert(Tasks task) async {
    final db = await database;
    await db.rawInsert('INSERT INTO "' +
        list_name +
        '" VALUES ("' +
        task.task_name +
        '", ' +
        task.striked.toString() +
        ')');
  }

  changeState(Tasks task) async {
    final db = await database;
    await db.rawUpdate('UPDATE "' +
        list_name +
        '" SET strike = ' +
        task.striked.toString() +
        ' WHERE task = "' +
        task.task_name +
        '"');
  }

  delete(String str) async {
    final db = await database;
    await db.rawDelete('DELETE FROM "' + list_name + '" WHERE task = ?', [str]);
  }

  finish() async {
    final db = await database;

    await db.close();
    _database = null;
  }
}
