// To parse this JSON data, do
//
//     final userVote = userVoteFromJson(jsonString);

import 'dart:convert';

import 'package:loudly/data/database.dart';
import 'package:loudly/models/polldata.dart';
import 'package:loudly/models/userinfo.dart';
import 'package:sqflite/sqflite.dart';

UserVote userVoteFromJson(String str) => UserVote.fromJson(json.decode(str));

String userVoteToJson(UserVote data) => json.encode(data.toJson());

class UserVote {
  static final String tablename = 'pollvotedata';

  int pollid;
  int userId;
  String votetype;
  int option;
  int votedAt;

  UserVote({
    this.pollid,
    this.userId,
    this.votetype,
    this.option,
    this.votedAt,
  });

  factory UserVote.fromJson(Map<String, dynamic> json) => new UserVote(
        pollid: json["pollid"],
        userId: json["user_id"],
        votetype: json["votetype"],
        option: json["option"],
        votedAt: json["votedat"],
      );

  Map<String, dynamic> toJson() => {
        "pollid": pollid,
        "user_id": userId,
        "votetype": votetype,
        "option": option,
        "votedat": votedAt,
      };

  static Future<void> createTable(Database db) async {
    // Create the users table
    await db.execute('''CREATE TABLE ${UserVote.tablename}(
          pollid INTEGER DEFAULT -1, 
          user_id INTEGER DEFAULT -1,
          votetype TEXT,
          option INTEGER DEFAULT -1,
          votedat INTEGER DEFAULT -1,
          PRIMARY KEY (pollid, user_id)
          FOREIGN KEY (pollid) REFERENCES ${PollData.tablename}(pollid) 
          ON DELETE CASCADE
          FOREIGN KEY (user_id) REFERENCES ${UserInfo.tablename}(user_id) 
          ON DELETE CASCADE
        )''');
  }

  static Future<void> insert(UserVote data) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same groupInfo is inserted
    // multiple times, it replaces the previous data.
    await db.insert(
      UserVote.tablename,
      data.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<UserVote>> getVotesByPoll(int pollid) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Query the table for all The dogs.
    final List<Map<String, dynamic>> maps = await db
        .query(UserVote.tablename, where: 'pollid = ?', whereArgs: [pollid]);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return UserVote.fromJson(maps[i]);
    });
  }

  static Future<List<UserVote>> getVotesByPollUsers(
      int pollid, List<int> userids) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Query the table for all The dogs.
    final List<Map<String, dynamic>> maps = await db.query(UserVote.tablename,
        where: 'pollid = ? AND user_id IN ?', whereArgs: [pollid, userids]);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return UserVote.fromJson(maps[i]);
    });
  }
}
