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

  static final String columnUserId = 'user_id';
  static final String columnName = 'name';
  static final String columnStatusMsg = 'statusmsg';
  static final String columnPhoneNumber = 'phonenumber';
  static final String columnCreatedAt = 'createdAt';  
  static final String columnUpdatedAt = 'updatedAt';

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
      userId: json[UserInfo.columnUserId],
      name: json[UserInfo.columnName],
      statusMsg: json[UserInfo.columnStatusMsg],
      phoneNumber: json[UserInfo.columnPhoneNumber],
      createdAt: json[UserInfo.columnCreatedAt],
      updatedAt: json[UserInfo.columnUpdatedAt]);

  Map<String, dynamic> toJson() => {
        UserInfo.columnUserId: userId,
        UserInfo.columnName: name,
        UserInfo.columnStatusMsg: statusMsg,
        UserInfo.columnPhoneNumber: phoneNumber,
        UserInfo.columnCreatedAt: createdAt,
        UserInfo.columnUpdatedAt: updatedAt,
      };

  static Future<void> createTable(Database db) async {
    // Create the users table
    await db.execute('''CREATE TABLE ${UserInfo.tablename}(
      ${UserInfo.columnUserId} INTEGER PRIMARY KEY,
      ${UserInfo.columnName} TEXT DEFAULT '',
      ${UserInfo.columnStatusMsg} TEXT DEFAULT '',
      ${UserInfo.columnPhoneNumber} TEXT DEFAULT '',
      ${UserInfo.columnCreatedAt} INTEGER DEFAULT 0,
      ${UserInfo.columnUpdatedAt} INTEGER DEFAULT 0
    )''');
  }

  static Future<void> insert(UserInfo data) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same groupInfo is inserted
    // multiple times, it replaces the previous data.
    try {
      await db.insert(
        UserInfo.tablename,
        data.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (Exception) {
      print(Exception);
    }
  }

  static Future<List<UserInfo>> getAll() async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Query the table for all The dogs.
    final List<Map<String, dynamic>> maps = await db.query(UserInfo.tablename);

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
      where: '${UserInfo.columnUserId} = ?',
      whereArgs: [data.userId],
    );
  }

  static Future<void> delete(int id) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Remove the Dog from the database.
    await db.delete(
      UserInfo.tablename,
      where: '${UserInfo.columnUserId} = ?',
      whereArgs: [id],
    );
  }

  static Future<UserInfo> getOne(int id) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Get the Dog from the database.
    final List<Map<String, dynamic>> maps = await db.query(
      UserInfo.tablename,
      where: '${UserInfo.columnUserId} = ?',
      whereArgs: [id],
    );

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    List<UserInfo> users = List.generate(maps.length, (i) {
      return UserInfo.fromJson(maps[i]);
    });

    if (users.isNotEmpty)
      return users[0];
    else
      return null;
  }
}
