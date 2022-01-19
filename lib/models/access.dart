import 'dart:async';

import 'package:musclatax/models/train.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBAccess {
  static const dbName = "train.db";
  static const dbVersion = 2;

  static createAllTable(Database db) {
    var batch = db.batch();
    batch.execute("""CREATE TABLE IF NOT EXISTS week(
              id INTEGER PRIMARY KEY, 
              dateTime BIGINT NOT NULL
              );""");
    batch.execute("""CREATE TABLE IF NOT EXISTS sessions(
                id INTEGER PRIMARY KEY, 
                week INTEGER,
                dateTime INTEGER,
                done INTEGER,
                FOREIGN KEY(week) REFERENCES week(id)
                );
                """);
    batch.execute("""CREATE TABLE IF NOT EXISTS segments(
              id INTEGER PRIMARY KEY,
              session INTEGER,
              duration INTEGER NOT NULL, 
              data VARCHAR(20), 
              type INTEGER NOT NULL, 
              exercices TEXT,
              FOREIGN KEY(session) REFERENCES sessions(id)
              );""");
    batch.commit();
  }

  static Future<Database> openDb() async {
    return openDatabase(
      join(await getDatabasesPath(), dbName),
      onUpgrade: (db, oldVersion, newVersion) => createAllTable(db),
      onDowngrade: (db, oldVersion, newVersion) => createAllTable(db),
      onCreate: (db, version) => createAllTable(db),
      version: dbVersion,
    );
  }

  static Future<List<Week>> getWeeks() async {
    final db = await openDb();

    List<Map<String, dynamic>> result = await db.query("week");
    db.close();

    return List.generate(result.length, (i) => Week.fromSerial(result[i]));
  }

  static Future<List<Session>> getSessions(Week week) async {
    final db = await openDb();

    List<Map<String, dynamic>> result = await db.query("sessions");
    db.close();

    return List.generate(result.length, (i) => Session.fromSerial(result[i]));
  }

  static Future<List<Segment>> getSegment(Session session) async {
    final db = await openDb();

    List<Map<String, dynamic>> result = await db.query("segments");

    db.close();

    return List.generate(result.length, (i) => Segment.fromSerial(result[i]));
  }

  static Future<int> insertNewWeek(Week newWeek) async {
    final db = await openDb();

    var newWeekMap = newWeek.toMap();
    newWeekMap.removeWhere((key, value) => key == "id");

    return await db.insert("week", newWeekMap,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static void removeWeek(Week extracted) async {
    final db = await openDb();

    await db.delete("week", where: "id = ?", whereArgs: [extracted.id]);
  }

  /*
      id INTEGER PRIMARY KEY, 
      week INTEGER,
      dateTime INTEGER,
      done INTEGER,
  */
  static Future<int> insertNewSession(Week week, Session newSession) async {
    final db = await openDb();
    var newSessionMap = newSession.toMap();
    newSessionMap.removeWhere((key, value) => key == "id");
    newSessionMap["done"] = 0; // false
    newSessionMap["week"] = week.id;

    return await db.insert("sessions", newSessionMap);
  }

  static void removeSession(Week week, Session session) async {
    final db = await openDb();

    await db.delete("sessions",
        where: "id = ? AND week = ?", whereArgs: [session.id, week.id]);
  }
}
