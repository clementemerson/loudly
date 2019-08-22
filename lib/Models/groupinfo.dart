// To parse this JSON data, do
//
//     final groupInfo = groupInfoFromJson(jsonString);

import 'dart:convert';

import 'package:loudly/data/database.dart';
import 'package:loudly/providers/group.dart';
import 'package:loudly/providers/grouplist.dart';

import 'package:sqflite/sqflite.dart';

GroupInfo groupInfoFromJson(String str) => GroupInfo.fromJson(json.decode(str));

List<GroupInfo> groupInfoFromList(List<dynamic> list) =>
    new List<GroupInfo>.from(list.map((x) => GroupInfo.fromJson(x)));

String groupInfoToJson(GroupInfo data) => json.encode(data.toJson());

class GroupInfo {
  static final String tablename = 'groupinfo';
  static final String columnGroupId = 'groupid';
  static final String columnName = 'name';
  static final String columnDesc = 'desc';
  static final String columnCreatedBy = 'createdby';
  static final String columnCreatedAt = 'createdAt';
  static final String columnSorttime = 'sorttime';

  int groupid;
  String name;
  String desc;
  int createdBy;
  int createdAt;

  GroupInfo({
    this.groupid,
    this.name,
    this.desc,
    this.createdBy,
    this.createdAt,
  });

  factory GroupInfo.fromJson(Map<String, dynamic> json) => new GroupInfo(
        groupid: json[GroupInfo.columnGroupId],
        name: json[GroupInfo.columnName],
        desc: json[GroupInfo.columnDesc],
        createdBy: json[GroupInfo.columnCreatedBy],
        createdAt: json[GroupInfo.columnCreatedAt],
      );

  Map<String, dynamic> toJson() => {
        GroupInfo.columnGroupId: groupid,
        GroupInfo.columnName: name,
        GroupInfo.columnDesc: desc,
        GroupInfo.columnCreatedBy: createdBy,
        GroupInfo.columnCreatedAt: createdAt,
      };

  static Future<void> createTable(Database db) async {
    // Create the groupinfo table
    await db.execute('''CREATE TABLE ${GroupInfo.tablename}(
          ${GroupInfo.columnGroupId} INTEGER PRIMARY KEY, 
          ${GroupInfo.columnName} TEXT DEFAULT '',
          ${GroupInfo.columnDesc} TEXT DEFAULT '',
          ${GroupInfo.columnCreatedBy} INTEGER DEFAULT -1,
          ${GroupInfo.columnCreatedAt} INTEGER DEFAULT 0,
          ${GroupInfo.columnSorttime} INTEGER DEFAULT 0
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

    GroupStore.store.addGroup(
        group: Group(
            groupid: groupInfo.groupid,
            title: groupInfo.name,
            desc: groupInfo.desc,
            createdBy: groupInfo.createdBy,
            createdAt: groupInfo.createdAt));
  }

  static Future<List<GroupInfo>> getAll() async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Query the table for all The dogs.
    final List<Map<String, dynamic>> maps = await db.query(GroupInfo.tablename,
        orderBy: '${GroupInfo.columnCreatedAt} DESC');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return GroupInfo.fromJson(maps[i]);
    });
  }

  static Future<void> updateTitle(int groupid, String name) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Update the given Dog.
    await db.update(
      GroupInfo.tablename,
      {GroupInfo.columnName: name},
      where: '${GroupInfo.columnGroupId} = ?',
      whereArgs: [groupid],
    );

    GroupStore.store.findById(id: groupid).updateTitle(title: name);
  }

  static Future<void> updateDesc(int groupid, String desc) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Update the given Dog.
    await db.update(
      GroupInfo.tablename,
      {GroupInfo.columnDesc: desc},
      where: '${GroupInfo.columnGroupId} = ?',
      whereArgs: [groupid],
    );

    GroupStore.store.findById(id: groupid).updateDescription(desc: desc);
  }

  static Future<void> delete(int id) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Remove the Dog from the database.
    await db.delete(
      GroupInfo.tablename,
      where: '${GroupInfo.columnGroupId} = ?',
      whereArgs: [id],
    );
  }

  static Future<void> updateSortTime(int id) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Update the given Dog.
    await db.update(
      GroupInfo.tablename,
      {GroupInfo.columnSorttime: DateTime.now().millisecondsSinceEpoch},
      where: '${GroupInfo.columnGroupId} = ?',
      whereArgs: [id],
    );
  }
}
