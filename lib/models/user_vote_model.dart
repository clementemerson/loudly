// To parse this JSON data, do
//
//     final userVote = userVoteFromJson(jsonString);

import 'dart:convert';

import 'package:loudly/data/database.dart';
import 'package:loudly/models/poll_data_model.dart';
import 'package:loudly/models/user_info_model.dart';
import 'package:sqflite/sqflite.dart';

UserVoteModel userVoteFromJson(String str) => UserVoteModel.fromJson(json.decode(str));

String userVoteToJson(UserVoteModel data) => json.encode(data.toJson());

List<UserVoteModel> userVoteFromList(List<dynamic> list) {
  List<UserVoteModel> userVoteList = List<UserVoteModel>();
  for (var item in list) {
    UserVoteModel userVote = UserVoteModel.fromJson(item);
    if (userVote != null) userVoteList.add(userVote);
  }
  return userVoteList;
}

class UserVoteModel {
  static final String tablename = 'pollvotedata';
  static final String columnPollId = 'pollid';
  static final String columnUserId = 'user_id';
  static final String columnVoteType = 'issecret';
  static final String columnOption = 'option';
  static final String columnVotedAt = 'votedat';

  int pollid;
  int userId;
  bool isSecret;
  int option;
  int votedAt;

  UserVoteModel({
    this.pollid,
    this.userId,
    this.isSecret,
    this.option,
    this.votedAt,
  });

  factory UserVoteModel.fromJson(Map<String, dynamic> json) => new UserVoteModel(
        pollid: json[UserVoteModel.columnPollId],
        userId: json[UserVoteModel.columnUserId],
        isSecret: json[UserVoteModel.columnVoteType],
        option: json[UserVoteModel.columnOption],
        votedAt: json[UserVoteModel.columnVotedAt],
      );

  Map<String, dynamic> toJson() => {
        UserVoteModel.columnPollId: pollid,
        UserVoteModel.columnUserId: userId,
        UserVoteModel.columnVoteType: isSecret,
        UserVoteModel.columnOption: option,
        UserVoteModel.columnVotedAt: votedAt,
      };

  static Future<void> createTable(Database db) async {
    // Create the users table
    await db.execute('''CREATE TABLE ${UserVoteModel.tablename}(
          ${UserVoteModel.columnPollId} INTEGER DEFAULT -1, 
          ${UserVoteModel.columnUserId} INTEGER DEFAULT -1,
          ${UserVoteModel.columnVoteType} INTEGER DEFAULT -1,
          ${UserVoteModel.columnOption} INTEGER DEFAULT -1,
          ${UserVoteModel.columnVotedAt} INTEGER DEFAULT -1,
          PRIMARY KEY (${UserVoteModel.columnPollId}, ${UserVoteModel.columnUserId})
          FOREIGN KEY (${UserVoteModel.columnPollId}) 
          REFERENCES ${PollDataModel.tablename}(${PollDataModel.columnPollId}) 
          ON DELETE CASCADE
          FOREIGN KEY (${UserVoteModel.columnUserId}) 
          REFERENCES ${UserInfoModel.tablename}(${UserInfoModel.columnUserId}) 
          ON DELETE CASCADE
        )''');
  }

  static Future<void> insert(UserVoteModel data) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same groupInfo is inserted
    // multiple times, it replaces the previous data.
    await db.insert(
      UserVoteModel.tablename,
      data.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<UserVoteModel>> getVotesByPoll(int pollid) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Query the table for all The dogs.
    final List<Map<String, dynamic>> maps = await db.query(UserVoteModel.tablename,
        where: '${UserVoteModel.columnPollId} = ?', whereArgs: [pollid]);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return UserVoteModel.fromJson(maps[i]);
    });
  }

  static Future<List<UserVoteModel>> getVotesByPollUsers(
      int pollid, List<int> userids) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Query the table for all The dogs.
    final List<Map<String, dynamic>> maps = await db.query(UserVoteModel.tablename,
        where: '${UserVoteModel.columnPollId} = ? AND ${UserVoteModel.columnUserId} IN ?',
        whereArgs: [pollid, userids]);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return UserVoteModel.fromJson(maps[i]);
    });
  }
}
