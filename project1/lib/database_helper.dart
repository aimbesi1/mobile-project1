import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:project1/flashcard.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static const _databaseName = "CardDB.db";
  static const _databaseVersion = 1;

  static const setsTable = 'sets';
  static const columnSetId = '_sid';
  static const columnSetName = 'name';

  static const cardsTable = 'cards';
  static const columnCardId = '_cid';
  static const columnFront = 'front';
  static const columnBack = 'back';
  static const columnSetKey = 'sid';

  late Database _db;

  // this opens the database (and creates it if it doesn't exist)
  Future<void> init() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);

    // await deleteDatabase(path); // Start over

    _db = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $setsTable (
        $columnSetId INTEGER PRIMARY KEY,
        $columnSetName TEXT NOT NULL
      );
      ''');

    await db.execute('''
      CREATE TABLE $cardsTable (
        $columnCardId INTEGER PRIMARY KEY,
        $columnFront TEXT NOT NULL,
        $columnBack TEXT NOT NULL,
        $columnSetKey INTEGER,
        FOREIGN KEY ($columnSetKey) REFERENCES $setsTable($columnSetId)
      );
      ''');
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insertCard(FlashCard card, int setId) async {
    Map<String, dynamic> cardMap = card.toMap();
    cardMap['sid'] = setId;
    return await _db.insert(cardsTable, cardMap,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insertCardSet(Map<String, dynamic> row) async {
    return await _db.insert(setsTable, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllSets() async {
    return await _db.query(setsTable);
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryCardCount(int setId) async {
    final results = await _db.rawQuery('''
        SELECT COUNT(*) FROM $cardsTable
        WHERE $columnSetKey = $setId
        ''');
    return Sqflite.firstIntValue(results) ?? 0;
  }

  // Count the number of sets
  Future<int> querySetCount() async {
    final results = await _db.rawQuery('''
        SELECT COUNT(*) FROM $setsTable
        ''');
    return Sqflite.firstIntValue(results) ?? 0;
  }

  Future<List<FlashCard>> queryAllCardsOfSet(int id) async {
    final List<Map<String, dynamic>> maps = await _db.rawQuery('''
          SELECT * FROM $cardsTable
          WHERE $columnSetKey = $id
          ''');

    return List.generate(maps.length, (i) {
      return FlashCard(
          id: maps[i]['_cid'], front: maps[i]['front'], back: maps[i]['back'], setId: maps[i]['sid']);
    });
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> updateCard(FlashCard card) async {
    int id = card.id!;
    return await _db.update(
      cardsTable,
      card.toMap(),
      where: '$columnCardId = ?',
      whereArgs: [id],
    );
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> deleteCard(int id) async {
    return await _db.delete(
      cardsTable,
      where: '$columnCardId = ?',
      whereArgs: [id],
    );
  }

  Future<void> printTables() async {
    for (var row in (await _db.query('sqlite_master', columns: ['type', 'name']))) {
      debugPrint('${row.values}');
    }
  }

  Future<void> deleteDatabase(String path) async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final dbPath = join(documentsDirectory.path, _databaseName);
    if (await File(dbPath).exists()) {
      await File(dbPath).delete();
      debugPrint("Database deleted.");
    }
  }
}
