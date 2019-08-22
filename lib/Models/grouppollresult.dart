// To parse this JSON data, do
//
//     final groupPollResult = groupPollResultFromJson(jsonString);

import 'dart:convert';

import 'package:loudly/models/polldata.dart';
import 'package:loudly/data/database.dart';
import 'package:loudly/models/groupinfo.dart';

import 'package:sqflite/sqflite.dart';

GroupPollResult groupPollResultFromJson(Map<String, dynamic> json) =>
    GroupPollResult.fromJson(json);

String groupPollResultToJson(GroupPollResult data) =>
    json.encode(data.toJson());

class GroupPollResult {
  static final String tablename = 'grouppollresult';
  static final String columnPollId = 'pollid';
  static final String columnGroupId = 'groupid';
  static final String columnOptionIndex = 'optionindex';
  static final String columnOpenVotes = 'openVotes';
  static final String jsonOptions = 'options';

  int pollId;
  int groupId;
  String groupName;
  List<PollOptionModel> options;

  GroupPollResult({
    this.pollId,
    this.groupId,
    this.groupName,
    this.options,
  });

  factory GroupPollResult.fromJson(Map<String, dynamic> json) =>
      new GroupPollResult(
        pollId: json[GroupPollResult.columnPollId],
        groupId: json[GroupPollResult.columnGroupId],
        options: new List<PollOptionModel>.from(
            json[GroupPollResult.jsonOptions]
                .map((x) => PollOptionModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        GroupPollResult.columnPollId: pollId,
        GroupPollResult.columnGroupId: groupId,
        GroupPollResult.jsonOptions:
            new List<dynamic>.from(options.map((x) => x.toJson())),
      };

  static Future<void> createTable(Database db) async {
    // Create the grouppoll table
    await db.execute('''CREATE TABLE ${GroupPollResult.tablename}(
          ${GroupPollResult.columnPollId} INTEGER, 
          ${GroupPollResult.columnGroupId} INTEGER,
          ${GroupPollResult.columnOptionIndex} INTEGER DEFAULT -1,
          ${GroupPollResult.columnOpenVotes} INTEGER DEFAULT 0,
          PRIMARY KEY (${GroupPollResult.columnPollId}, ${GroupPollResult.columnGroupId}, ${GroupPollResult.columnOptionIndex})
          FOREIGN KEY (${GroupPollResult.columnPollId}) 
          REFERENCES ${PollDataModel.tablename}(${PollDataModel.columnPollId}) 
          ON DELETE CASCADE
          FOREIGN KEY (${GroupPollResult.columnGroupId}) 
          REFERENCES ${GroupInfo.tablename}(${GroupInfo.columnGroupId}) 
          ON DELETE CASCADE
        )''');
  }

  static Future<void> insert(GroupPollResult groupPollResult) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same groupInfo is inserted
    // multiple times, it replaces the previous data.
    for (PollOptionModel option in groupPollResult.options) {
      //Prepare data
      dynamic data = {
        GroupPollResult.columnPollId: groupPollResult.pollId,
        GroupPollResult.columnGroupId: groupPollResult.groupId,
        GroupPollResult.columnOptionIndex: option.optionindex,
        GroupPollResult.columnOpenVotes: option.openVotes,
      };
      await db.insert(
        GroupInfo.tablename,
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  static Future<List<GroupInfo>> getByGroupAndPoll(
      int groupid, int pollid) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Query the table for all The dogs.
    final List<Map<String, dynamic>> maps = await db.query(GroupInfo.tablename,
        where:
            '${GroupPollResult.columnGroupId} = ? AND ${GroupPollResult.columnPollId} = ?',
        whereArgs: [groupid, pollid]);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return GroupInfo.fromJson(maps[i]);
    });
  }
}
