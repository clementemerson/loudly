// To parse this JSON data, do
//
//     final userInfo = userInfoFromJson(jsonString);

import 'dart:convert';
import 'package:loudly/data/database.dart';
import 'package:sqflite/sqflite.dart';

List<UserInfoModel> userInfoFromJson(String str) =>
    new List<UserInfoModel>.from(json.decode(str).map((x) => UserInfoModel.fromJson(x)));

List<UserInfoModel> userInfoFromList(List<dynamic> list) =>
    new List<UserInfoModel>.from(list.map((x) => UserInfoModel.fromJson(x)));

String userInfoToJson(List<UserInfoModel> data) =>
    json.encode(new List<dynamic>.from(data.map((x) => x.toJson())));

class UserInfoModel {
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

  UserInfoModel({
    this.userId,
    this.name,
    this.statusMsg,
    this.phoneNumber,
    this.createdAt,
    this.updatedAt,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) => new UserInfoModel(
      userId: json[UserInfoModel.columnUserId],
      name: json[UserInfoModel.columnName],
      statusMsg: json[UserInfoModel.columnStatusMsg],
      phoneNumber: json[UserInfoModel.columnPhoneNumber],
      createdAt: json[UserInfoModel.columnCreatedAt],
      updatedAt: json[UserInfoModel.columnUpdatedAt]);

  Map<String, dynamic> toJson() => {
        UserInfoModel.columnUserId: userId,
        UserInfoModel.columnName: name,
        UserInfoModel.columnStatusMsg: statusMsg,
        UserInfoModel.columnPhoneNumber: phoneNumber,
        UserInfoModel.columnCreatedAt: createdAt,
        UserInfoModel.columnUpdatedAt: updatedAt,
      };

  static Future<void> createTable(Database db) async {
    // Create the users table
    await db.execute('''CREATE TABLE ${UserInfoModel.tablename}(
      ${UserInfoModel.columnUserId} INTEGER PRIMARY KEY,
      ${UserInfoModel.columnName} TEXT DEFAULT '',
      ${UserInfoModel.columnStatusMsg} TEXT DEFAULT '',
      ${UserInfoModel.columnPhoneNumber} TEXT DEFAULT '',
      ${UserInfoModel.columnCreatedAt} INTEGER DEFAULT 0,
      ${UserInfoModel.columnUpdatedAt} INTEGER DEFAULT 0
    )''');
  }

  static Future<void> insert(UserInfoModel data) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same groupInfo is inserted
    // multiple times, it replaces the previous data.
    try {
      await db.insert(
        UserInfoModel.tablename,
        data.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (Exception) {
      print(Exception);
    }
  }

  static Future<List<UserInfoModel>> getAll() async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Query the table for all The dogs.
    final List<Map<String, dynamic>> maps = await db.query(UserInfoModel.tablename);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return UserInfoModel.fromJson(maps[i]);
    });
  }

  static Future<void> update(UserInfoModel data) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Update the given Dog.
    await db.update(
      UserInfoModel.tablename,
      data.toJson(),
      where: '${UserInfoModel.columnUserId} = ?',
      whereArgs: [data.userId],
    );
  }

  static Future<void> delete(int id) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Remove the Dog from the database.
    await db.delete(
      UserInfoModel.tablename,
      where: '${UserInfoModel.columnUserId} = ?',
      whereArgs: [id],
    );
  }

  static Future<UserInfoModel> getOne(int id) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Get the Dog from the database.
    final List<Map<String, dynamic>> maps = await db.query(
      UserInfoModel.tablename,
      where: '${UserInfoModel.columnUserId} = ?',
      whereArgs: [id],
    );

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    List<UserInfoModel> users = List.generate(maps.length, (i) {
      return UserInfoModel.fromJson(maps[i]);
    });

    if (users.isNotEmpty)
      return users[0];
    else
      return null;
  }
}
