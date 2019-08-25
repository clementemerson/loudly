// To parse this JSON data, do
//
//     final groupUser = groupUserFromJson(jsonString);

import 'dart:convert';

import 'package:loudly/data/database.dart';
import 'package:loudly/models/group_info_model.dart';
import 'package:loudly/models/user_info_model.dart';

import 'package:sqflite/sqflite.dart';

GroupUserModel groupUserFromJson(String str) => GroupUserModel.fromJson(json.decode(str));

List<GroupUserModel> groupUserFromList(List<dynamic> list) =>
    new List<GroupUserModel>.from(list.map((x) => GroupUserModel.fromJson(x)));

String groupUserToJson(GroupUserModel data) => json.encode(data.toJson());

class GroupUserModel {
  static final String tablename = 'groupusers';
  static final String columnGroupId = 'groupid';
  static final String columnUserId = 'user_id';
  static final String columnAddedBy = 'addedby';  
  static final String columnPermission = 'permission';
  static final String columnCreatedAt = 'createdAt';

  int groupid;
  int userId;
  int addedBy;
  String permission;
  int createdAt;

  GroupUserModel({
    this.groupid,
    this.userId,
    this.addedBy,
    this.permission,
    this.createdAt,
  });

  factory GroupUserModel.fromJson(Map<String, dynamic> json) => new GroupUserModel(
      groupid: json[GroupUserModel.columnGroupId],
      userId: json[GroupUserModel.columnUserId],
      addedBy: json[GroupUserModel.columnAddedBy],
      permission: json[GroupUserModel.columnPermission],
      createdAt: json[GroupUserModel.columnCreatedAt]);

  Map<String, dynamic> toJson() => {
        GroupUserModel.columnGroupId: groupid,
        GroupUserModel.columnUserId: userId,
        GroupUserModel.columnAddedBy: addedBy,
        GroupUserModel.columnPermission: permission,
        GroupUserModel.columnCreatedAt: createdAt,
      };

  static Future<void> createTable(Database db) async {
    // Create the users table
    await db.execute('''CREATE TABLE ${GroupUserModel.tablename}(
          ${GroupUserModel.columnGroupId} INTEGER DEFAULT -1, 
          ${GroupUserModel.columnUserId} INTEGER DEFAULT -1,
          ${GroupUserModel.columnAddedBy} INTEGER DEFAULT -1,
          ${GroupUserModel.columnPermission} TEXT DEFAULT 'USER',
          ${GroupUserModel.columnCreatedAt} INTEGER DEFAULT 0,
          PRIMARY KEY (${GroupUserModel.columnGroupId}, ${GroupUserModel.columnUserId})
          FOREIGN KEY (${GroupUserModel.columnUserId}) 
          REFERENCES ${UserInfoModel.tablename}(${UserInfoModel.columnUserId}) 
          ON DELETE CASCADE
          FOREIGN KEY (${GroupUserModel.columnGroupId}) 
          REFERENCES ${GroupInfoModel.tablename}(${GroupInfoModel.columnGroupId}) 
          ON DELETE CASCADE
        )''');
  }

  static Future<void> insert(GroupUserModel data) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same groupInfo is inserted
    // multiple times, it replaces the previous data.
    await db.insert(
      GroupUserModel.tablename,
      data.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<GroupUserModel>> getUsersOfGroup(int groupid) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Query the table for all The dogs.
    final List<Map<String, dynamic>> maps = await db
        .query(GroupUserModel.tablename, where: '${GroupUserModel.columnGroupId} = ?', whereArgs: [groupid]);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return GroupUserModel.fromJson(maps[i]);
    });
  }

  static Future<void> updatePermission(
      int groupid, int userid, String permission) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Update the given Dog.
    await db.update(
      GroupUserModel.tablename,
      {GroupUserModel.columnPermission: permission},
      where: "${GroupUserModel.columnGroupId} = ? AND ${GroupUserModel.columnUserId} = ?",
      whereArgs: [groupid, userid],
    );
  }

  static Future<void> delete(int groupid, int userId) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Remove the Dog from the database.
    await db.delete(
      GroupUserModel.tablename,
      where: "${GroupUserModel.columnGroupId} = ? AND ${GroupUserModel.columnUserId} = ?",
      whereArgs: [groupid, userId],
    );
  }

  static Future<List<GroupUserModel>> getGroupsOfUser(int userId) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Get the Dog from the database.
    final List<Map<String, dynamic>> maps = await db.query(
      GroupUserModel.tablename,
      where: "${GroupUserModel.columnUserId} = ?",
      whereArgs: [userId],
    );

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return GroupUserModel.fromJson(maps[i]);
    });
  }

  static Future<List<GroupUserModel>> getAll() async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Get the Dog from the database.
    final List<Map<String, dynamic>> maps = await db.query(GroupUserModel.tablename);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return GroupUserModel.fromJson(maps[i]);
    });
  }
}
