// To parse this JSON data, do
//
//     final groupPoll = groupPollFromJson(jsonString);

import 'dart:convert';

import 'package:loudly/data/database.dart';
import 'package:loudly/models/group_info_model.dart';
import 'package:loudly/models/poll_data_model.dart';
import 'package:loudly/providers/group_store.dart';

import 'package:sqflite/sqflite.dart';

GroupPollModel groupPollFromJson(String str) =>
    GroupPollModel.fromJson(json.decode(str));

List<GroupPollModel> groupPollFromList(List<dynamic> list) =>
    new List<GroupPollModel>.from(list.map((x) => GroupPollModel.fromJson(x)));

String groupPollToJson(GroupPollModel data) => json.encode(data.toJson());

class GroupPollModel {
  static final String tablename = 'grouppoll';
  static final String columnPollId = 'pollid';
  static final String columnGroupId = 'groupid';
  static final String columnSharedBy = 'sharedby';
  static final String columnCreatedAt = 'createdAt';
  static final String columnArchived = 'archived';

  int pollid;
  int groupid;
  int sharedBy;
  int createdAt;
  bool archived;

  GroupPollModel({
    this.pollid,
    this.groupid,
    this.sharedBy,
    this.createdAt,
    this.archived,
  });

  factory GroupPollModel.fromJson(Map<String, dynamic> json) =>
      new GroupPollModel(
        pollid: json[GroupPollModel.columnPollId],
        groupid: json[GroupPollModel.columnGroupId],
        sharedBy: json[GroupPollModel.columnSharedBy],
        createdAt: json[GroupPollModel.columnCreatedAt],
        archived: false,
      );

  Map<String, dynamic> toJson() => {
        GroupPollModel.columnPollId: pollid,
        GroupPollModel.columnGroupId: groupid,
        GroupPollModel.columnSharedBy: sharedBy,
        GroupPollModel.columnCreatedAt: createdAt,
        GroupPollModel.columnArchived: archived,
      };

  static Future<void> createTable(Database db) async {
    // Create the grouppoll table
    await db.execute('''CREATE TABLE ${GroupPollModel.tablename}(
          ${GroupPollModel.columnPollId} INTEGER, 
          ${GroupPollModel.columnGroupId} INTEGER,
          ${GroupPollModel.columnSharedBy} INTEGER DEFAULT -1,
          ${GroupPollModel.columnCreatedAt} INTEGER DEFAULT 0,
          ${GroupPollModel.columnArchived} INTEGER DEFAULT 0,
          PRIMARY KEY (${GroupPollModel.columnPollId}, ${GroupPollModel.columnGroupId})
          FOREIGN KEY (${GroupPollModel.columnPollId}) 
          REFERENCES ${PollDataModel.tablename}(${PollDataModel.columnPollId}) 
          ON DELETE CASCADE
          FOREIGN KEY (${GroupPollModel.columnGroupId}) 
          REFERENCES ${GroupInfoModel.tablename}(${GroupInfoModel.columnGroupId}) 
          ON DELETE CASCADE
        )''');
  }

  static Future<void> insert(GroupPollModel groupPoll) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same groupPoll is inserted
    // multiple times, it replaces the previous data.
    await db.insert(
      GroupPollModel.tablename,
      groupPoll.toJson(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );

    GroupStore.store
        .findById(id: groupPoll.groupid)
        .addPoll(pollid: groupPoll.pollid);
  }

  static Future<List<int>> getAll() async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Query the table for all The dogs.
    final List<Map<String, dynamic>> maps = await db.query(
        GroupPollModel.tablename,
        distinct: true,
        columns: [GroupPollModel.columnPollId],
        orderBy: '${GroupPollModel.columnCreatedAt} DESC');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return maps[i][GroupPollModel.columnPollId];
    });
  }
}
