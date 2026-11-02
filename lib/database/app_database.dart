import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';

import '../models/schedule_entry.dart';

class AppDatabase {
  AppDatabase._();
  static final AppDatabase instance = AppDatabase._();

  static const _table = 'class_schedule';

  // The database is opened only once. Every later call reuses this same Future.
  Future<Database>? _dbFuture;
  Future<Database> get database => _dbFuture ??= _open();

  Future<Database> _open() async {
    final dbPath = join(await getDatabasesPath(), 'pocket_notes.db');
    return openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE class_schedule (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            subject TEXT NOT NULL,
            room TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insert(ScheduleEntry entry) async {
    final db = await database;
    return db.insert(_table, entry.toMap());
  }

  Future<List<ScheduleEntry>> getAll() async {
    final db = await database;
    final rows = await db.query(_table, orderBy: 'id ASC');

    // TEMPORARY: proof for Screenshot 7. Remove after capturing.
    debugPrint('--- class_schedule rows ---');
    for (final row in rows) {
      debugPrint(row.toString());
    }

    return rows.map(ScheduleEntry.fromMap).toList();
  }

  Future<int> update(ScheduleEntry entry) async {
    final db = await database;
    return db.update(
      _table,
      entry.toMap(),
      where: 'id = ?',
      whereArgs: [entry.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await database;
    return db.delete(_table, where: 'id = ?', whereArgs: [id]);
  }
}
