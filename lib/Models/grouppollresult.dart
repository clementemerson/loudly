// To parse this JSON data, do
//
//     final groupPollResult = groupPollResultFromJson(jsonString);

import 'dart:convert';

import 'package:loudly/Models/polldata.dart';
import 'package:loudly/data/database.dart';
import 'package:loudly/models/groupinfo.dart';

import 'package:sqflite/sqflite.dart';

GroupPollResult groupPollResultFromJson(Map<String, dynamic> json) =>
    GroupPollResult.fromJson(json);

String groupPollResultToJson(GroupPollResult data) =>
    json.encode(data.toJson());

class GroupPollResult {
  static final String tablename = 'grouppollresult';

  int pollId;
  int groupId;
  String groupName;
  List<PollOption> options;

  GroupPollResult({
    this.pollId,
    this.groupId,
    this.groupName,
    this.options,
  });

  factory GroupPollResult.fromJson(Map<String, dynamic> json) =>
      new GroupPollResult(
        pollId: json["pollId"],
        groupId: json["groupId"],
        options: new List<PollOption>.from(
            json["options"].map((x) => PollOption.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pollId": pollId,
        "groupId": groupId,
        "options": new List<dynamic>.from(options.map((x) => x.toJson())),
      };

  static Future<void> createTable(Database db) async {
    // Create the grouppoll table
    await db.execute('''CREATE TABLE ${GroupPollResult.tablename}(
          pollid INTEGER, 
          groupid INTEGER,
          optionindex INTEGER DEFAULT -1,
          openvotes INTEGER DEFAULT 0,
          PRIMARY KEY (pollid, groupid, optionindex)
        )''');
  }

  static Future<void> insert(GroupPollResult groupPollResult) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same groupInfo is inserted
    // multiple times, it replaces the previous data.
    for (PollOption option in groupPollResult.options) {
      //Prepare data
      dynamic data = {
        "pollId": groupPollResult.pollId,
        "groupId": groupPollResult.groupId,
        "optionindex": option.index,
        "openvotes": option.openVotes,
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
        where: 'groupid = ? AND pollid = ?', whereArgs: [groupid, pollid]);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return GroupInfo.fromJson(maps[i]);
    });
  }
}
