// To parse this JSON data, do
//
//     final userPoll = userPollFromJson(jsonString);

import 'dart:convert';

import 'package:loudly/data/database.dart';
import 'package:loudly/models/polldata.dart';

import 'package:sqflite/sqflite.dart';

UserPoll userPollFromJson(String str) => UserPoll.fromJson(json.decode(str));

List<UserPoll> userPollFromList(List<dynamic> list) =>
    new List<UserPoll>.from(list.map((x) => UserPoll.fromJson(x)));

String userPollToJson(UserPoll data) => json.encode(data.toJson());

class UserPoll {
  static final String tablename = 'userpolls';
  static final String columnPollId = 'pollid';
  static final String columnSharedBy = 'sharedby';
  static final String columnCreatedAt = 'createdAt';
  static final String columnUpdatedAt = 'updatedAt';

  int pollid;
  int sharedby;
  int createdAt;
  int updatedAt;

  UserPoll({
    this.pollid,
    this.sharedby,
    this.createdAt,
    this.updatedAt,
  });

  factory UserPoll.fromJson(Map<String, dynamic> json) => new UserPoll(
        pollid: json[UserPoll.columnPollId],
        sharedby: json[UserPoll.columnSharedBy],
        createdAt: json[UserPoll.columnCreatedAt],
        updatedAt: json[UserPoll.columnUpdatedAt]
      );

  Map<String, dynamic> toJson() => {
        UserPoll.columnPollId: pollid,
        UserPoll.columnSharedBy: sharedby,
        UserPoll.columnCreatedAt: createdAt,
        UserPoll.columnUpdatedAt: updatedAt,
      };

  static Future<void> createTable(Database db) async {
    // Create the users table
    await db.execute('''CREATE TABLE ${UserPoll.tablename}(
      ${UserPoll.columnPollId} INTEGER PRIMARY KEY, 
      ${UserPoll.columnSharedBy} INTEGER DEFAULT -1,
      ${UserPoll.columnCreatedAt} INTEGER DEFAULT 0,
      ${UserPoll.columnUpdatedAt} INTEGER DEFAULT 0,
      FOREIGN KEY (${UserPoll.columnPollId}) 
      REFERENCES ${PollData.tablename}(${PollData.columnPollId}) 
      ON DELETE CASCADE
    )''');
  }

  static Future<void> insert(UserPoll data) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same groupInfo is inserted
    // multiple times, it replaces the previous data.
    await db.insert(
      UserPoll.tablename,
      data.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<UserPoll>> getAll() async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Query the table for all The dogs.
    final List<Map<String, dynamic>> maps =
        await db.query(UserPoll.tablename, orderBy: '${UserPoll.columnUpdatedAt} DESC');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return UserPoll.fromJson(maps[i]);
    });
  }

  static Future<void> update(UserPoll data) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Update the given Dog.
    await db.update(
      UserPoll.tablename,
      data.toJson(),
      where: "${UserPoll.columnPollId} = ?",
      whereArgs: [data.pollid],
    );
  }

  static Future<void> delete(int id) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Remove the Dog from the database.
    await db.delete(
      UserPoll.tablename,
      where: "${UserPoll.columnPollId} = ?",
      whereArgs: [id],
    );
  }

  static Future<UserPoll> getOne(int id) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Get the Dog from the database.
    final List<Map<String, dynamic>> maps = await db.query(
      UserPoll.tablename,
      where: "${UserPoll.columnPollId} = ?",
      whereArgs: [id],
    );

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    List<UserPoll> userPolls = List.generate(maps.length, (i) {
      return UserPoll.fromJson(maps[i]);
    });

    if (userPolls.isNotEmpty)
      return userPolls[0];
    else
      return null;
  }
}
