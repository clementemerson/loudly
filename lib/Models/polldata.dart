// To parse this JSON data, do
//
//     final pollData = pollDataFromJson(jsonString);

import 'dart:convert';

import 'package:loudly/data/database.dart';
import 'package:sqflite/sqflite.dart';

PollData pollDataFromJson(Map<String, dynamic> map) => PollData.fromJson(map);

List<PollData> pollInfoFromList(List<dynamic> list) =>
    new List<PollData>.from(list.map((x) => PollData.fromJson(x)));

String pollDataToJson(PollData data) => json.encode(data.toJson());

class PollData {
  static final String tablename = 'polldata';

  int pollid;
  String title;
  List<PollOption> options;
  bool canBeShared;
  bool resultIsPublic;
  int createdBy;
  int createdAt;
  bool voted;

  PollData(
      {this.pollid,
      this.title,
      this.options,
      this.canBeShared,
      this.resultIsPublic,
      this.createdBy,
      this.createdAt,
      this.voted});

  factory PollData.fromJson(Map<String, dynamic> json) => new PollData(
        pollid: json["pollid"],
        title: json["title"],
        options: new List<PollOption>.from(json["options"]
            .map((x) => PollOption.fromJson(x, pollid: json["pollid"]))),
        canBeShared: json["canbeshared"],
        resultIsPublic: json["resultispublic"],
        createdBy: json["createdby"],
        createdAt: int.parse(json["createdAt"]),
        voted: json["voted"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "pollid": pollid,
        "title": title,
        "options": new List<dynamic>.from(options.map((x) => x.toJson())),
        "canbeshared": canBeShared,
        "resultispublic": resultIsPublic,
        "createdby": createdBy,
        "createdAt": createdAt,
        "voted": voted,
      };

  static Future<void> createTable() async {
    final Database db = await DBProvider.db.database;

    // Create the grouppoll table
    await db.execute('''CREATE TABLE ${PollData.tablename}(
          pollid INTEGER PRIMARY KEY, 
          title TEXT,
          canbeshared INTEGER DEFAULT 0,
          resultispublic INTEGER DEFAULT 0,
          createdby INTEGER DEFAULT 0,
          createdAt INTEGER DEFAULT 0,
          voted INTEGER DEFAULT 0,
        )''');
  }

  static Future<void> insert(PollData data) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same groupInfo is inserted
    // multiple times, it replaces the previous data.
    await db.insert(
      PollData.tablename,
      data.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    data.options.forEach((option) {
      PollOption.insert(option);
    });
  }

  static Future<List<PollData>> getAll() async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Query the table for all The dogs.
    final List<Map<String, dynamic>> maps =
        await db.query(PollData.tablename, orderBy: 'createdAt DESC');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return PollData.fromJson(maps[i]);
    });
  }

  static Future<PollData> getOne(int pollid) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Get the Dog from the database.
    final List<Map<String, dynamic>> maps = await db.query(
      PollData.tablename,
      where: "pollid = ?",
      whereArgs: [pollid],
    );

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    List<PollData> polls = List.generate(maps.length, (i) {
      return PollData.fromJson(maps[i]);
    });

    if (polls.length > 0)
      return polls[0];
    else
      return null;
  }

  static Future<void> delete(int pollid) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Remove the Dog from the database.
    await db.delete(
      PollData.tablename,
      where: "pollid = ?",
      whereArgs: [pollid],
    );

    await PollOption.delete(pollid);
  }
}

class PollOption {
  static final String tablename = 'polloptions';

  int pollid;
  int index;
  String desc;
  int openVotes;
  int secretVotes;

  PollOption({
    this.pollid,
    this.index,
    this.desc,
    this.openVotes,
    this.secretVotes,
  });

  factory PollOption.fromJson(Map<String, dynamic> json, {int pollid}) =>
      new PollOption(
        pollid: pollid ?? json[pollid],
        index: json["index"],
        desc: json["desc"] ?? '',
        openVotes: json["openVotes"],
        secretVotes: json["secretVotes"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "pollid": pollid,
        "index": index,
        "desc": desc,
        "openVotes": openVotes,
        "secretVotes": secretVotes,
      };

  static Future<void> createTable() async {
    final Database db = await DBProvider.db.database;

    // Create the grouppoll table
    await db.execute('''CREATE TABLE ${PollOption.tablename}(
          pollid INTEGER, 
          optionindex INTEGER DEFAULT -1,
          desc TEXT,
          openvotes INTEGER DEFAULT 0,
          secretvotes INTEGER DEFAULT 0,
          PRIMARY KEY (pollid, optionindex)
        )''');
  }

  static Future<void> insert(PollOption data) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same groupInfo is inserted
    // multiple times, it replaces the previous data.
    await db.insert(
      PollOption.tablename,
      data.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<PollOption>> getOptionsOfPoll(int pollid) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Query the table for all The dogs.
    final List<Map<String, dynamic>> maps = await db
        .query(PollOption.tablename, where: 'pollid = ?', whereArgs: [pollid]);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return PollOption.fromJson(maps[i]);
    });
  }

  static Future<void> update(PollOption data) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Update the given Dog.
    await db.update(
      PollOption.tablename,
      data.toJson(),
      where: "pollid = ? AND optionindex = ?",
      whereArgs: [data.pollid, data.index],
    );
  }

  static Future<void> delete(int pollid) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Remove the Dog from the database.
    await db.delete(
      PollOption.tablename,
      where: "pollid = ?",
      whereArgs: [pollid],
    );
  }
}
