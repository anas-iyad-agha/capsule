import 'dart:core';

import 'package:path/path.dart' show join;
import 'package:sqflite/sqflite.dart';

class Localdb {
  static Database? db;
  static init() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'medicine_schedule.db');

    // open the database
    db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
              CREATE TABLE IF NOT EXISTS medicine (id INTEGER PRIMARY KEY, name TEXT, description TEXT, dose REAL, strength REAL);
          ''');
        await db.execute('''
              CREATE TABLE IF NOT EXISTS reminders (id INTEGER PRIMARY KEY AUTOINCREMENT, medicine_id INTEGER NOT NULL, medicine_name TEXT NOT NULL, date_time INTEGER NOT NULL, label TEXT NOT NULL,  is_taken INTEGER NOT NULL, FOREIGN KEY (medicine_id) REFERENCES medicines (id) ON UPDATE NO ACTION ON DELETE CASCADE)
          ''');
        await db.execute('''
              CREATE TABLE IF NOT EXISTS reports (id INTEGER PRIMARY KEY, date_time TEXT, status TEXT, description TEXT);
          ''');
        await db.execute('''
              CREATE TABLE IF NOT EXISTS attachments (id INTEGER PRIMARY KEY, report_id INTEGER, file_path TEXT, FOREIGN KEY (report_id) REFERENCES reports(id) ON UPDATE NO ACTION ON DELETE CASCADE);
          ''');
      },
    );
  }
}
