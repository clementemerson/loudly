// To parse this JSON data, do
//
//     final userPoll = userPollFromJson(jsonString);

import 'dart:convert';

import 'package:loudly/data/database.dart';
import 'package:sqflite/sqflite.dart';

UserPoll userPollFromJson(String str) => UserPoll.fromJson(json.decode(str));

List<UserPoll> userPollFromList(List<dynamic> list) =>
    new List<UserPoll>.from(list.map((x) => UserPoll.fromJson(x)));

String userPollToJson(UserPoll data) => json.encode(data.toJson());

class UserPoll {
  static final String tablename = 'userpolls';

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
        pollid: json["pollid"],
        sharedby: json["sharedby"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
      );

  Map<String, dynamic> toJson() => {
        "pollid": pollid,
        "sharedby": sharedby,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };

  static Future<void> createTable() async {
    final Database db = await DBProvider.db.database;

    // Create the users table
    await db.execute('''CREATE TABLE ${UserPoll.tablename}(
      pollid INTEGER DEFAULT -1, 
      sharedby INTEGER DEFAULT -1,
      createdAt INTEGER DEFAULT 0,
      updatedAt INTEGER DEFAULT 0
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
        await db.query(UserPoll.tablename, orderBy: 'updatedAt DESC');

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
      where: "pollid = ?",
      whereArgs: [data.pollid],
    );
  }

  static Future<void> delete(BigInt id) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Remove the Dog from the database.
    await db.delete(
      UserPoll.tablename,
      where: "pollid = ?",
      whereArgs: [id],
    );
  }

  static Future<UserPoll> getOne(BigInt id) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Get the Dog from the database.
    final List<Map<String, dynamic>> maps = await db.query(
      UserPoll.tablename,
      where: "pollid = ?",
      whereArgs: [id],
    );

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    List<UserPoll> data = List.generate(maps.length, (i) {
      return UserPoll.fromJson(maps[i]);
    });

    if (data.length > 0)
      return data[0];
    else
      return null;
  }
}
