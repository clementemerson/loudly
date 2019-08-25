// To parse this JSON data, do
//
//     final userVote = userVoteFromJson(jsonString);

import 'dart:convert';

import 'package:loudly/data/database.dart';
import 'package:loudly/models/poll_data_model.dart';
import 'package:loudly/models/user_info_model.dart';
import 'package:sqflite/sqflite.dart';

UserVote userVoteFromJson(String str) => UserVote.fromJson(json.decode(str));

String userVoteToJson(UserVote data) => json.encode(data.toJson());

class UserVote {
  static final String tablename = 'pollvotedata';
  static final String columnPollId = 'pollid';
  static final String columnUserId = 'user_id';
  static final String columnVoteType = 'votetype';
  static final String columnOption = 'option';
  static final String columnVotedAt = 'votedat';

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
        pollid: json[UserVote.columnPollId],
        userId: json[UserVote.columnUserId],
        votetype: json[UserVote.columnVoteType],
        option: json[UserVote.columnOption],
        votedAt: json[UserVote.columnVotedAt],
      );

  Map<String, dynamic> toJson() => {
        UserVote.columnPollId: pollid,
        UserVote.columnUserId: userId,
        UserVote.columnVoteType: votetype,
        UserVote.columnOption: option,
        UserVote.columnVotedAt: votedAt,
      };

  static Future<void> createTable(Database db) async {
    // Create the users table
    await db.execute('''CREATE TABLE ${UserVote.tablename}(
          ${UserVote.columnPollId} INTEGER DEFAULT -1, 
          ${UserVote.columnUserId} INTEGER DEFAULT -1,
          ${UserVote.columnVoteType} TEXT,
          ${UserVote.columnOption} INTEGER DEFAULT -1,
          ${UserVote.columnVotedAt} INTEGER DEFAULT -1,
          PRIMARY KEY (${UserVote.columnPollId}, ${UserVote.columnUserId})
          FOREIGN KEY (${UserVote.columnPollId}) 
          REFERENCES ${PollDataModel.tablename}(${PollDataModel.columnPollId}) 
          ON DELETE CASCADE
          FOREIGN KEY (${UserVote.columnUserId}) 
          REFERENCES ${UserInfoModel.tablename}(${UserInfoModel.columnUserId}) 
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
    final List<Map<String, dynamic>> maps = await db.query(UserVote.tablename,
        where: '${UserVote.columnPollId} = ?', whereArgs: [pollid]);

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
        where: '${UserVote.columnPollId} = ? AND ${UserVote.columnUserId} IN ?',
        whereArgs: [pollid, userids]);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return UserVote.fromJson(maps[i]);
    });
  }
}
