// To parse this JSON data, do
//
//     final groupInfo = groupInfoFromJson(jsonString);

import 'dart:convert';

import 'package:loudly/data/database.dart';
import 'package:loudly/providers/group.dart';
import 'package:loudly/providers/group_store.dart';

import 'package:sqflite/sqflite.dart';

GroupInfoModel groupInfoFromJson(String str) =>
    GroupInfoModel.fromJson(json.decode(str));

List<GroupInfoModel> groupInfoFromList(List<dynamic> list) =>
    new List<GroupInfoModel>.from(list.map((x) => GroupInfoModel.fromJson(x)));

String groupInfoToJson(GroupInfoModel data) => json.encode(data.toJson());

class GroupInfoModel {
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

  GroupInfoModel({
    this.groupid,
    this.name,
    this.desc,
    this.createdBy,
    this.createdAt,
  });

  factory GroupInfoModel.fromJson(Map<String, dynamic> json) =>
      new GroupInfoModel(
        groupid: json[GroupInfoModel.columnGroupId],
        name: json[GroupInfoModel.columnName],
        desc: json[GroupInfoModel.columnDesc],
        createdBy: json[GroupInfoModel.columnCreatedBy],
        createdAt: json[GroupInfoModel.columnCreatedAt],
      );

  Map<String, dynamic> toJson() => {
        GroupInfoModel.columnGroupId: groupid,
        GroupInfoModel.columnName: name,
        GroupInfoModel.columnDesc: desc,
        GroupInfoModel.columnCreatedBy: createdBy,
        GroupInfoModel.columnCreatedAt: createdAt,
      };

  static Future<void> createTable(Database db) async {
    // Create the groupinfo table
    await db.execute('''CREATE TABLE ${GroupInfoModel.tablename}(
          ${GroupInfoModel.columnGroupId} INTEGER PRIMARY KEY, 
          ${GroupInfoModel.columnName} TEXT DEFAULT '',
          ${GroupInfoModel.columnDesc} TEXT DEFAULT '',
          ${GroupInfoModel.columnCreatedBy} INTEGER DEFAULT -1,
          ${GroupInfoModel.columnCreatedAt} INTEGER DEFAULT 0,
          ${GroupInfoModel.columnSorttime} INTEGER DEFAULT 0
        )''');
  }

  static Future<void> insert(GroupInfoModel groupInfo) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same groupInfo is inserted
    // multiple times, it replaces the previous data.
    await db.insert(
      GroupInfoModel.tablename,
      groupInfo.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    GroupStore.store.addGroup(
        newGroup: Group(
            groupid: groupInfo.groupid,
            title: groupInfo.name,
            desc: groupInfo.desc,
            createdBy: groupInfo.createdBy,
            createdAt: groupInfo.createdAt));
  }

  static Future<List<GroupInfoModel>> getAll() async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Query the table for all The dogs.
    final List<Map<String, dynamic>> maps = await db.query(
        GroupInfoModel.tablename,
        orderBy: '${GroupInfoModel.columnCreatedAt}');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return GroupInfoModel.fromJson(maps[i]);
    });
  }

  static Future<void> updateTitle(int groupid, String name) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Update the given Dog.
    await db.update(
      GroupInfoModel.tablename,
      {GroupInfoModel.columnName: name},
      where: '${GroupInfoModel.columnGroupId} = ?',
      whereArgs: [groupid],
    );

    GroupStore.store.findById(id: groupid).updateTitle(title: name);
  }

  static Future<void> updateDesc(int groupid, String desc) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Update the given Dog.
    await db.update(
      GroupInfoModel.tablename,
      {GroupInfoModel.columnDesc: desc},
      where: '${GroupInfoModel.columnGroupId} = ?',
      whereArgs: [groupid],
    );

    GroupStore.store.findById(id: groupid).updateDescription(desc: desc);
  }

  static Future<void> delete(int id) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Remove the Dog from the database.
    await db.delete(
      GroupInfoModel.tablename,
      where: '${GroupInfoModel.columnGroupId} = ?',
      whereArgs: [id],
    );
  }

  static Future<void> updateSortTime(int id) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Update the given Dog.
    await db.update(
      GroupInfoModel.tablename,
      {GroupInfoModel.columnSorttime: DateTime.now().millisecondsSinceEpoch},
      where: '${GroupInfoModel.columnGroupId} = ?',
      whereArgs: [id],
    );
  }
}
