// To parse this JSON data, do
//
//     final groupUser = groupUserFromJson(jsonString);

import 'dart:convert';

import 'package:loudly/data/database.dart';
import 'package:loudly/models/groupinfo.dart';
import 'package:loudly/models/userinfo.dart';

import 'package:sqflite/sqflite.dart';

GroupUser groupUserFromJson(String str) => GroupUser.fromJson(json.decode(str));

List<GroupUser> groupUserFromList(List<dynamic> list) =>
    new List<GroupUser>.from(list.map((x) => GroupUser.fromJson(x)));

String groupUserToJson(GroupUser data) => json.encode(data.toJson());

class GroupUser {
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

  GroupUser({
    this.groupid,
    this.userId,
    this.addedBy,
    this.permission,
    this.createdAt,
  });

  factory GroupUser.fromJson(Map<String, dynamic> json) => new GroupUser(
      groupid: json[GroupUser.columnGroupId],
      userId: json[GroupUser.columnUserId],
      addedBy: json[GroupUser.columnAddedBy],
      permission: json[GroupUser.columnPermission],
      createdAt: json[GroupUser.columnCreatedAt]);

  Map<String, dynamic> toJson() => {
        GroupUser.columnGroupId: groupid,
        GroupUser.columnUserId: userId,
        GroupUser.columnAddedBy: addedBy,
        GroupUser.columnPermission: permission,
        GroupUser.columnCreatedAt: createdAt,
      };

  static Future<void> createTable(Database db) async {
    // Create the users table
    await db.execute('''CREATE TABLE ${GroupUser.tablename}(
          ${GroupUser.columnGroupId} INTEGER DEFAULT -1, 
          ${GroupUser.columnUserId} INTEGER DEFAULT -1,
          ${GroupUser.columnAddedBy} INTEGER DEFAULT -1,
          ${GroupUser.columnPermission} TEXT DEFAULT 'USER',
          ${GroupUser.columnCreatedAt} INTEGER DEFAULT 0,
          PRIMARY KEY (${GroupUser.columnGroupId}, ${GroupUser.columnUserId})
          FOREIGN KEY (${GroupUser.columnUserId}) 
          REFERENCES ${UserInfo.tablename}(${UserInfo.columnUserId}) 
          ON DELETE CASCADE
          FOREIGN KEY (${GroupUser.columnGroupId}) 
          REFERENCES ${GroupInfo.tablename}(${GroupInfo.columnGroupId}) 
          ON DELETE CASCADE
        )''');
  }

  static Future<void> insert(GroupUser data) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same groupInfo is inserted
    // multiple times, it replaces the previous data.
    await db.insert(
      GroupUser.tablename,
      data.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<GroupUser>> getUsersOfGroup(int groupid) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Query the table for all The dogs.
    final List<Map<String, dynamic>> maps = await db
        .query(GroupUser.tablename, where: '${GroupUser.columnGroupId} = ?', whereArgs: [groupid]);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return GroupUser.fromJson(maps[i]);
    });
  }

  static Future<void> updatePermission(
      int groupid, int userid, String permission) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Update the given Dog.
    await db.update(
      GroupUser.tablename,
      {GroupUser.columnPermission: permission},
      where: "${GroupUser.columnGroupId} = ? AND ${GroupUser.columnUserId} = ?",
      whereArgs: [groupid, userid],
    );
  }

  static Future<void> delete(int groupid, int userId) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Remove the Dog from the database.
    await db.delete(
      GroupUser.tablename,
      where: "${GroupUser.columnGroupId} = ? AND ${GroupUser.columnUserId} = ?",
      whereArgs: [groupid, userId],
    );
  }

  static Future<List<GroupUser>> getGroupsOfUser(int userId) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Get the Dog from the database.
    final List<Map<String, dynamic>> maps = await db.query(
      GroupUser.tablename,
      where: "${GroupUser.columnUserId} = ?",
      whereArgs: [userId],
    );

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return GroupUser.fromJson(maps[i]);
    });
  }

  static Future<List<GroupUser>> getAll() async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Get the Dog from the database.
    final List<Map<String, dynamic>> maps = await db.query(GroupUser.tablename);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return GroupUser.fromJson(maps[i]);
    });
  }
}
