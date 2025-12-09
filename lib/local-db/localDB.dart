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
              CREATE TABLE IF NOT EXISTS medicine (id INTEGER PRIMARY KEY, name TEXT, description TEXT, dose REAL, strength REAL, start_date TEXT, end_date TEXT);
          ''');
        await db.execute('''
              CREATE TABLE IF NOT EXISTS reminders (id INTEGER PRIMARY KEY AUTOINCREMENT, medicine_id INTEGER NOT NULL, medicine_name TEXT NOT NULL, date_time INTEGER NOT NULL, label TEXT NOT NULL,  is_taken INTEGER NOT NULL, FOREIGN KEY (medicine_id) REFERENCES medicines (id) ON UPDATE NO ACTION ON DELETE CASCADE)
          ''');
        await db.execute('''
              CREATE TABLE IF NOT EXISTS illnesses (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, description TEXT NOT NULL, type TEXT)
          ''');
        await db.execute('''
              CREATE TABLE IF NOT EXISTS operations (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, description TEXT)
          ''');
        await db.execute('''
              CREATE TABLE IF NOT EXISTS tests (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, date TEXT NOT NULL, attachment TEXT)
          ''');
      },
    );
  }
}
