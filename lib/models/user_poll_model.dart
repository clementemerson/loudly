// To parse this JSON data, do
//
//     final userPoll = userPollFromJson(jsonString);

import 'dart:convert';

import 'package:loudly/data/database.dart';
import 'package:loudly/models/poll_data_model.dart';

import 'package:sqflite/sqflite.dart';

UserPollModel userPollFromJson(String str) =>
    UserPollModel.fromJson(json.decode(str));

List<UserPollModel> userPollFromList(List<dynamic> list) =>
    new List<UserPollModel>.from(list.map((x) => UserPollModel.fromJson(x)));

String userPollToJson(UserPollModel data) => json.encode(data.toJson());

class UserPollModel {
  static final String tablename = 'userpolls';
  static final String columnPollId = 'pollid';
  static final String columnSharedBy = 'sharedby';
  static final String columnCreatedAt = 'createdAt';
  static final String columnUpdatedAt = 'updatedAt';

  int pollid;
  int sharedby;
  int createdAt;
  int updatedAt;

  UserPollModel({
    this.pollid,
    this.sharedby,
    this.createdAt,
    this.updatedAt,
  });

  factory UserPollModel.fromJson(Map<String, dynamic> json) =>
      new UserPollModel(
          pollid: json[UserPollModel.columnPollId],
          sharedby: json[UserPollModel.columnSharedBy],
          createdAt: json[UserPollModel.columnCreatedAt],
          updatedAt: json[UserPollModel.columnUpdatedAt]);

  Map<String, dynamic> toJson() => {
        UserPollModel.columnPollId: pollid,
        UserPollModel.columnSharedBy: sharedby,
        UserPollModel.columnCreatedAt: createdAt,
        UserPollModel.columnUpdatedAt: updatedAt,
      };

  static Future<void> createTable(Database db) async {
    // Create the users table
    await db.execute('''CREATE TABLE ${UserPollModel.tablename}(
      ${UserPollModel.columnPollId} INTEGER PRIMARY KEY, 
      ${UserPollModel.columnSharedBy} INTEGER DEFAULT -1,
      ${UserPollModel.columnCreatedAt} INTEGER DEFAULT 0,
      ${UserPollModel.columnUpdatedAt} INTEGER DEFAULT 0,
      FOREIGN KEY (${UserPollModel.columnPollId}) 
      REFERENCES ${PollDataModel.tablename}(${PollDataModel.columnPollId}) 
      ON DELETE CASCADE
    )''');
  }

  static Future<void> insert(UserPollModel data) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same groupInfo is inserted
    // multiple times, it replaces the previous data.
    await db.insert(
      UserPollModel.tablename,
      data.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<UserPollModel>> getAll() async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Query the table for all The dogs.
    final List<Map<String, dynamic>> maps = await db.query(
        UserPollModel.tablename,
        orderBy: '${UserPollModel.columnUpdatedAt} DESC');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return UserPollModel.fromJson(maps[i]);
    });
  }

  static Future<void> update(UserPollModel data) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Update the given Dog.
    await db.update(
      UserPollModel.tablename,
      data.toJson(),
      where: "${UserPollModel.columnPollId} = ?",
      whereArgs: [data.pollid],
    );
  }

  static Future<void> delete(int id) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Remove the Dog from the database.
    await db.delete(
      UserPollModel.tablename,
      where: "${UserPollModel.columnPollId} = ?",
      whereArgs: [id],
    );
  }

  static Future<UserPollModel> getOne(int id) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Get the Dog from the database.
    final List<Map<String, dynamic>> maps = await db.query(
      UserPollModel.tablename,
      where: "${UserPollModel.columnPollId} = ?",
      whereArgs: [id],
    );

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    List<UserPollModel> userPolls = List.generate(maps.length, (i) {
      return UserPollModel.fromJson(maps[i]);
    });

    if (userPolls.isNotEmpty)
      return userPolls[0];
    else
      return null;
  }
}
