import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:musclatax/model/view.list.dart';
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';
import 'package:http/http.dart' as http;
import 'package:musclatax/tools/helper.dart';
part 'model.g.dart';
part 'model.view.dart';

const SqfEntityTable tableExercices = SqfEntityTable(
    tableName: "exercices",
    primaryKeyName: "id",
    useSoftDeleting: false,
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      SqfEntityField("name", DbType.text, isNotNull: true),
      SqfEntityField("rest", DbType.integer, defaultValue: 60),
      SqfEntityField("series", DbType.integer, defaultValue: 4),
      SqfEntityField("reps", DbType.integer, defaultValue: 8),
      SqfEntityField("day", DbType.integer, isNotNull: true)
    ]);

const SqfEntityTable tablePerformed = SqfEntityTable(
    tableName: "performed",
    primaryKeyName: "id",
    useSoftDeleting: false,
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      SqfEntityFieldRelationship(
          parentTable: tableExercices,
          fieldName: "exercice",
          isNotNull: true,
          isPrimaryKeyField: false),
      SqfEntityField("seriesIndex", DbType.integer, isNotNull: true),
      SqfEntityField("weight", DbType.integer, isNotNull: true),
      SqfEntityField("date", DbType.datetimeUtc, isNotNull: true)
    ]);

const seqIdentity = SqfEntitySequence(
  sequenceName: 'identity',
  // maxValue:  10000, /* optional. default is max int (9.223.372.036.854.775.807) */
  // modelName: 'SQEidentity',
  /* optional. SqfEntity will set it to sequenceName automatically when the modelName is null*/
  // cycle : false,   /* optional. default is false; */
  // minValue = 0;    /* optional. default is 0 */
  // incrementBy = 1; /* optional. default is 1 */
  // startWith = 0;   /* optional. default is 0 */
);

@SqfEntityBuilder(myDbModel)
const myDbModel = SqfEntityModel(
    modelName: 'MyDbModel', // optional
    databaseName: 'sampleORM.db',
    password:
        null, // You can set a password if you want to use crypted database
    // put defined tables into the tables list.
    databaseTables: [tableExercices, tablePerformed],
    formTables: [tableExercices],
    // put defined sequences into the sequences list.
    sequences: [seqIdentity],
    bundledDatabasePath:
        null // 'assets/sample.db' // This value is optional. When bundledDatabasePath is empty then EntityBase creats a new database when initializing the database
    );
