// To parse this JSON data, do
//
//     final userInfo = userInfoFromJson(jsonString);

import 'dart:convert';

import 'package:loudly/data/database.dart';
import 'package:sqflite/sqflite.dart';

List<UserInfo> userInfoFromJson(String str) =>
    new List<UserInfo>.from(json.decode(str).map((x) => UserInfo.fromJson(x)));

List<UserInfo> userInfoFromList(List<dynamic> list) =>
    new List<UserInfo>.from(list.map((x) => UserInfo.fromJson(x)));

String userInfoToJson(List<UserInfo> data) =>
    json.encode(new List<dynamic>.from(data.map((x) => x.toJson())));

class UserInfo {
  static final String tablename = 'users';

  int userId;
  String name;
  String statusMsg;
  String phoneNumber;
  int createdAt;
  int updatedAt;

  UserInfo({
    this.userId,
    this.name,
    this.statusMsg,
    this.phoneNumber,
    this.createdAt,
    this.updatedAt,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) => new UserInfo(
        userId: json["user_id"],
        name: json["name"],
        statusMsg: json["statusmsg"],
        phoneNumber: json["phonenumber"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"]
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "name": name,
        "statusmsg": statusMsg,
        "phonenumber": phoneNumber,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };

  static Future<void> createTable() async {
    final Database db = await DBProvider.db.database;

    // Create the users table
    await db.execute('''CREATE TABLE ${UserInfo.tablename}(
      user_id INTEGER PRIMARY KEY,
      name TEXT DEFAULT '',
      statusmsg TEXT DEFAULT '',
      phonenumber TEXT DEFAULT '',
      createdAt INTEGER DEFAULT 0,
      updatedAt INTEGER DEFAULT 0
    )''');
  }

  static Future<void> insert(UserInfo data) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same groupInfo is inserted
    // multiple times, it replaces the previous data.
    await db.insert(
      UserInfo.tablename,
      data.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<UserInfo>> getAll() async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Query the table for all The dogs.
    final List<Map<String, dynamic>> maps =
        await db.query(UserInfo.tablename, orderBy: 'sorttime DESC');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return UserInfo.fromJson(maps[i]);
    });
  }

  static Future<void> update(UserInfo data) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Update the given Dog.
    await db.update(
      UserInfo.tablename,
      data.toJson(),
      where: "user_id = ?",
      whereArgs: [data.userId],
    );
  }

  static Future<void> delete(int id) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Remove the Dog from the database.
    await db.delete(
      UserInfo.tablename,
      where: "user_id = ?",
      whereArgs: [id],
    );
  }

  static Future<UserInfo> getOne(int id) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Get the Dog from the database.
    final List<Map<String, dynamic>> maps = await db.query(
      UserInfo.tablename,
      where: "user_id = ?",
      whereArgs: [id],
    );

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    List<UserInfo> users = List.generate(maps.length, (i) {
      return UserInfo.fromJson(maps[i]);
    });

    if (users.length > 0)
      return users[0];
    else
      return null;
  }
}
