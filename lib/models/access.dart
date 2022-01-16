import 'dart:async';

import 'package:musclatax/models/train.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBAccess {
  static const dbName = "train.db";
  static const dbVersion = 1;

  static Future<Database> openDb() async {
    return openDatabase(
      join(await getDatabasesPath(), dbName),
      onCreate: (db, version) {
        var batch = db.batch();
        batch.execute("""CREATE TABLE week(
              id INTEGER PRIMARY KEY, 
              dateTime BIGINT NOT NULL
              )""");
        batch.execute("""CREATE TABLE sessions(
                id INTEGER PRIMARY, 
                week INTEGER,
                dateTime BIGINT,
                done SMALLINT,
                FOREIGN KEY(week) REFERENCES week(id)
                )
                """);
        batch.execute("""CREATE TABLE segments(
              id INTEGER PRIMARY KEY,
              session INTEGER,
              duration INTEGER NOT NULL, 
              data VARCHAR(20), 
              type INTEGER NOT NULL, 
              exercices TEXT,
              FOREIGN KEY(session) REFERENCES sessions(id)
              )""");
        batch.commit();
      },
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
}
