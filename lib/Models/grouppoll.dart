// To parse this JSON data, do
//
//     final groupPoll = groupPollFromJson(jsonString);

import 'dart:convert';

import 'package:loudly/data/database.dart';
import 'package:loudly/models/groupinfo.dart';
import 'package:loudly/models/polldata.dart';

import 'package:sqflite/sqflite.dart';

GroupPoll groupPollFromJson(String str) => GroupPoll.fromJson(json.decode(str));

String groupPollToJson(GroupPoll data) => json.encode(data.toJson());

class GroupPoll {
  static final String tablename = 'grouppoll';

  int pollid;
  int groupid;
  int sharedBy;
  int createdAt;
  bool archived;

  GroupPoll({
    this.pollid,
    this.groupid,
    this.sharedBy,
    this.createdAt,
    this.archived,
  });

  factory GroupPoll.fromJson(Map<String, dynamic> json) => new GroupPoll(
        pollid: json["pollid"],
        groupid: json["groupid"],
        sharedBy: json["sharedBy"],
        createdAt: json["createdAt"],
        archived: false,
      );

  Map<String, dynamic> toJson() => {
        "pollid": pollid,
        "groupid": groupid,
        "sharedBy": sharedBy,
        "createdAt": createdAt,
        "archived": archived,
      };

  static Future<void> createTable() async {
    final Database db = await DBProvider.db.database;

    // Create the grouppoll table
    await db.execute('''CREATE TABLE ${GroupPoll.tablename}(
          pollid INTEGER, 
          groupid INTEGER,
          sharedBy INTEGER DEFAULT -1,
          createdAt INTEGER DEFAULT 0,
          archived INTEGER DEFAULT 0,
          PRIMARY KEY (pollid, group_id),
          FOREIGN KEY (pollid) REFERENCES contacts (${PollData.tablename}) 
          ON DELETE CASCADE ON UPDATE NO ACTION,
          FOREIGN KEY (group_id) REFERENCES contacts (${GroupInfo.tablename}) 
          ON DELETE CASCADE ON UPDATE NO ACTION,
        )''');
  }

  static Future<void> insert(GroupPoll groupPoll) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same groupPoll is inserted
    // multiple times, it replaces the previous data.
    await db.insert(
      GroupPoll.tablename,
      groupPoll.toJson(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  static Future<List<GroupPoll>> getAllByGroup(int groupid) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Query the table for all The dogs.
    final List<Map<String, dynamic>> maps = await db.query(GroupPoll.tablename,
        where: 'groupip = ?', whereArgs: [groupid], orderBy: 'createdAt DESC');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return GroupPoll.fromJson(maps[i]);
    });
  }

  static Future<void> archive(int pollid, int groupid, bool archive) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Remove the Dog from the database.
    await db.update(
      GroupPoll.tablename,
      {"archived": archive},
      where: "pollid = ? AND groupid = ?",
      whereArgs: [pollid, groupid],
    );
  }
}
