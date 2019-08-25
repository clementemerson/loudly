// To parse this JSON data, do
//
//     final groupPollResult = groupPollResultFromJson(jsonString);

import 'dart:convert';

import 'package:loudly/data/database.dart';
import 'package:loudly/models/group_info_model.dart';
import 'package:loudly/models/poll_data_model.dart';

import 'package:sqflite/sqflite.dart';

GroupPollResultModel groupPollResultFromJson(Map<String, dynamic> json) =>
    GroupPollResultModel.fromJson(json);

String groupPollResultToJson(GroupPollResultModel data) =>
    json.encode(data.toJson());

class GroupPollResultModel {
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

  GroupPollResultModel({
    this.pollId,
    this.groupId,
    this.groupName,
    this.options,
  });

  factory GroupPollResultModel.fromJson(Map<String, dynamic> json) =>
      new GroupPollResultModel(
        pollId: json[GroupPollResultModel.columnPollId],
        groupId: json[GroupPollResultModel.columnGroupId],
        options: new List<PollOptionModel>.from(
            json[GroupPollResultModel.jsonOptions]
                .map((x) => PollOptionModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        GroupPollResultModel.columnPollId: pollId,
        GroupPollResultModel.columnGroupId: groupId,
        GroupPollResultModel.jsonOptions:
            new List<dynamic>.from(options.map((x) => x.toJson())),
      };

  static Future<void> createTable(Database db) async {
    // Create the grouppoll table
    await db.execute('''CREATE TABLE ${GroupPollResultModel.tablename}(
          ${GroupPollResultModel.columnPollId} INTEGER, 
          ${GroupPollResultModel.columnGroupId} INTEGER,
          ${GroupPollResultModel.columnOptionIndex} INTEGER DEFAULT -1,
          ${GroupPollResultModel.columnOpenVotes} INTEGER DEFAULT 0,
          PRIMARY KEY (${GroupPollResultModel.columnPollId}, ${GroupPollResultModel.columnGroupId}, ${GroupPollResultModel.columnOptionIndex})
          FOREIGN KEY (${GroupPollResultModel.columnPollId}) 
          REFERENCES ${PollDataModel.tablename}(${PollDataModel.columnPollId}) 
          ON DELETE CASCADE
          FOREIGN KEY (${GroupPollResultModel.columnGroupId}) 
          REFERENCES ${GroupInfoModel.tablename}(${GroupInfoModel.columnGroupId}) 
          ON DELETE CASCADE
        )''');
  }

  static Future<void> insert(GroupPollResultModel groupPollResult) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same groupInfo is inserted
    // multiple times, it replaces the previous data.
    for (PollOptionModel option in groupPollResult.options) {
      //Prepare data
      dynamic data = {
        GroupPollResultModel.columnPollId: groupPollResult.pollId,
        GroupPollResultModel.columnGroupId: groupPollResult.groupId,
        GroupPollResultModel.columnOptionIndex: option.optionindex,
        GroupPollResultModel.columnOpenVotes: option.openVotes,
      };
      await db.insert(
        GroupInfoModel.tablename,
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  static Future<List<GroupInfoModel>> getByGroupAndPoll(
      int groupid, int pollid) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Query the table for all The dogs.
    final List<Map<String, dynamic>> maps = await db.query(GroupInfoModel.tablename,
        where:
            '${GroupPollResultModel.columnGroupId} = ? AND ${GroupPollResultModel.columnPollId} = ?',
        whereArgs: [groupid, pollid]);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return GroupInfoModel.fromJson(maps[i]);
    });
  }
}
