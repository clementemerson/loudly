// To parse this JSON data, do
//
//     final groupUser = groupUserFromJson(jsonString);

import 'dart:convert';

import 'package:loudly/data/database.dart';

import 'package:sqflite/sqflite.dart';

GroupUser groupUserFromJson(String str) => GroupUser.fromJson(json.decode(str));

List<GroupUser> groupUserFromList(List<dynamic> list) =>
    new List<GroupUser>.from(list.map((x) => GroupUser.fromJson(x)));

String groupUserToJson(GroupUser data) => json.encode(data.toJson());

class GroupUser {
  static final String tablename = 'groupusers';

  int groupid;
  int userId;
  int addedBy;
  String permission;
  int createdAt;
  int updatedAt;

  GroupUser({
    this.groupid,
    this.userId,
    this.addedBy,
    this.permission,
    this.createdAt,
    this.updatedAt,
  });

  factory GroupUser.fromJson(Map<String, dynamic> json) => new GroupUser(
      groupid: json["groupid"],
      userId: json["user_id"],
      addedBy: json["addedby"],
      permission: json["permission"],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"]);

  Map<String, dynamic> toJson() => {
        "groupid": groupid,
        "user_id": userId,
        "addedby": addedBy,
        "permission": permission,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };

  static Future<void> createTable(Database db) async {
    // Create the users table
    await db.execute('''CREATE TABLE ${GroupUser.tablename}(
          groupid INTEGER DEFAULT -1, 
          user_id INTEGER DEFAULT -1,
          addedby INTEGER DEFAULT -1,
          permission TEXT DEFAULT 'USER',
          createdAt INTEGER DEFAULT 0,
          updatedAt INTEGER DEFAULT 0,
          PRIMARY KEY (groupid, user_id)
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
        .query(GroupUser.tablename, where: 'groupid = ?', whereArgs: [groupid]);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return GroupUser.fromJson(maps[i]);
    });
  }

  static Future<void> update(GroupUser data) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Update the given Dog.
    await db.update(
      GroupUser.tablename,
      data.toJson(),
      where: "groupid = ? AND user_id = ?",
      whereArgs: [data.groupid, data.userId],
    );
  }

  static Future<void> delete(int groupid, int userId) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Remove the Dog from the database.
    await db.delete(
      GroupUser.tablename,
      where: "groupid = ? AND user_id = ?",
      whereArgs: [groupid, userId],
    );
  }

  static Future<List<GroupUser>> getGroupsOfUser(int userId) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Get the Dog from the database.
    final List<Map<String, dynamic>> maps = await db.query(
      GroupUser.tablename,
      where: "user_id = ?",
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
    final List<Map<String, dynamic>> maps = await db.query(
      GroupUser.tablename
    );

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return GroupUser.fromJson(maps[i]);
    });
  }
}
