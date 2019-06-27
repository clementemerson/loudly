// To parse this JSON data, do
//
//     final groupInfo = groupInfoFromJson(jsonString);

import 'dart:convert';

import 'package:loudly/data/database.dart';
import 'package:sqflite/sqflite.dart';

GroupInfo groupInfoFromJson(String str) => GroupInfo.fromJson(json.decode(str));

List<GroupInfo> groupInfoFromList(List<dynamic> list) =>
    new List<GroupInfo>.from(list.map((x) => GroupInfo.fromJson(x)));

String groupInfoToJson(GroupInfo data) => json.encode(data.toJson());

class GroupInfo {
  static final String tablename = 'groupinfo';

  int id;
  String name;
  String desc;
  int createdBy;
  int createdAt;
  int updatedAt;

  GroupInfo({
    this.id,
    this.name,
    this.desc,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory GroupInfo.fromJson(Map<String, dynamic> json) => new GroupInfo(
        id: json["id"],
        name: json["name"],
        desc: json["desc"],
        createdBy: json["createdBy"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "desc": desc,
        "createdBy": createdBy,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };

  static Future<void> createTable() async {
    final Database db = await DBProvider.db.database;

    // Create the groupinfo table
    await db.execute('''CREATE TABLE ${GroupInfo.tablename}(
          id INTEGER PRIMARY KEY, 
          name TEXT DEFAULT '',
          desc TEXT DEFAULT '',
          createdby INTEGER DEFAULT -1,
          createdAt INTEGER DEFAULT 0,
          updatedAt INTEGER DEFAULT 0,
          sorttime INTEGER DEFAULT 0
        )''');
  }

  static Future<void> insert(GroupInfo groupInfo) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same groupInfo is inserted
    // multiple times, it replaces the previous data.
    await db.insert(
      GroupInfo.tablename,
      groupInfo.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<GroupInfo>> getAll() async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Query the table for all The dogs.
    final List<Map<String, dynamic>> maps =
        await db.query(GroupInfo.tablename, orderBy: 'sorttime DESC');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return GroupInfo.fromJson(maps[i]);
    });
  }

  static Future<void> update(GroupInfo groupInfo) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Update the given Dog.
    await db.update(
      GroupInfo.tablename,
      groupInfo.toJson(),
      where: "id = ?",
      whereArgs: [groupInfo.id],
    );
  }

  static Future<void> delete(BigInt id) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Remove the Dog from the database.
    await db.delete(
      GroupInfo.tablename,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  static Future<GroupInfo> getOne(BigInt id) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Get the Dog from the database.
    final List<Map<String, dynamic>> maps = await db.query(
      GroupInfo.tablename,
      where: "id = ?",
      whereArgs: [id],
    );

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    List<GroupInfo> groups = List.generate(maps.length, (i) {
      return GroupInfo.fromJson(maps[i]);
    });

    if (groups.length > 0)
      return groups[0];
    else
      return null;
  }

  static Future<void> updateSortTime(BigInt id) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Update the given Dog.
    await db.update(
      GroupInfo.tablename,
      {'sorttime': DateTime.now().millisecondsSinceEpoch},
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
