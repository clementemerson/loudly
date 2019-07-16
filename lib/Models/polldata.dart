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

List<String> pollOptionListToJson(List<PollOption> list) =>
    new List<String>.from(list.map((x) => json.encode(x.toJsonForServer())));

List<PollOption> pollOptionFromList(List<dynamic> list, int pollid) {
  List<PollOption> pollOptions = List<PollOption>();
  for (String x in list) {
    pollOptions.add(PollOption.fromJson(json.decode(x), pollid: pollid));
  }
  return pollOptions;
}

//json.encode(data.toJson());

class PollData {
  static final String tablename = 'polldata';
  static final String columnPollId = 'pollid';
  static final String columnTitle = 'title';
  static final String columnCanBeShared = 'canbeshared';
  static final String columnResultIsPublic = 'resultispublic';
  static final String columnCreatedBy = 'createdby';
  static final String columnCreatedAt = 'createdAt';
  static final String columnVoted = 'voted';

  static final String jsonOptions = 'options';

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
        pollid: json[PollData.columnPollId],
        title: json[PollData.columnTitle],
        options: new List<PollOption>.from(json[PollData.jsonOptions]
            .map((x) => PollOption.fromJson(x, pollid: json[PollData.columnPollId]))),
        canBeShared: json[PollData.columnCanBeShared] == 0 ? false : true,
        resultIsPublic: json[PollData.columnResultIsPublic] == 0 ? false : true,
        createdBy: json[PollData.columnCreatedBy],
        createdAt: json[PollData.columnCreatedAt],
        voted: json[PollData.columnVoted] ?? false,
      );

  factory PollData.fromLocalDB(
          Map<String, dynamic> json, List<PollOption> pollOptions) =>
      new PollData(
        pollid: json[PollData.columnPollId],
        title: json[PollData.columnTitle],
        options: pollOptions,
        canBeShared: json[PollData.columnCanBeShared] == 0 ? false : true,
        resultIsPublic: json[PollData.columnResultIsPublic] == 0 ? false : true,
        createdBy: json[PollData.columnCreatedBy],
        createdAt: json[PollData.columnCreatedAt],
        voted: json[PollData.columnVoted] == 0 ? false : true,
      );

  Map<String, dynamic> toJson() => {
        PollData.columnPollId: pollid,
        PollData.columnTitle: title,
        //"options": new List<dynamic>.from(options.map((x) => x.toJson())),
        PollData.columnCanBeShared: canBeShared,
        PollData.columnResultIsPublic: resultIsPublic,
        PollData.columnCreatedBy: createdBy,
        PollData.columnCreatedAt: createdAt,
        PollData.columnVoted: voted,
      };

  static Future<void> createTable(Database db) async {
    // Create the grouppoll table
    await db.execute('''CREATE TABLE ${PollData.tablename}(
          ${PollData.columnPollId} INTEGER PRIMARY KEY, 
          ${PollData.columnTitle} TEXT,
          ${PollData.columnCanBeShared} INTEGER DEFAULT 0,
          ${PollData.columnResultIsPublic} INTEGER DEFAULT 0,
          ${PollData.columnCreatedBy} INTEGER DEFAULT 0,
          ${PollData.columnCreatedAt} INTEGER DEFAULT 0,
          ${PollData.columnVoted} INTEGER DEFAULT 0
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

    data.options.forEach((option) async {
      await PollOption.insert(option);
    });
  }

  static Future<List<PollData>> getAll() async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Query the table for all The dogs.
    List<Map<String, dynamic>> maps =
        await db.query(PollData.tablename, orderBy: '${PollData.columnCreatedAt} DESC');

    List<PollData> pollList = [];
    for (var poll in maps) {
      pollList.add(PollData.fromLocalDB(
          poll, await PollOption.getOptionsOfPoll(poll[PollData.columnPollId])));
    }

    return pollList;
  }

  static Future<List<PollData>> getUserCreatedPolls(int userId) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Query the table for all The dogs.
    List<Map<String, dynamic>> maps = await db.query(PollData.tablename,
        where: '${PollData.columnCreatedBy} = ?', whereArgs: [userId], orderBy: '${PollData.columnCreatedAt} DESC');

    List<PollData> pollList = [];
    for (var poll in maps) {
      pollList.add(PollData.fromLocalDB(
          poll, await PollOption.getOptionsOfPoll(poll[PollData.columnPollId])));
    }

    return pollList;
  }

  static Future<List<PollData>> getPollDataForPolls(List<int> pollids) async {
    if (pollids == null || (pollids != null && pollids.isEmpty))
      return List<PollData>();

    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    String commaSeparated = pollids.join(',');
    String query = "SELECT * FROM ${PollData.tablename} WHERE ${PollData.columnPollId} IN (" +
        commaSeparated +
        ")";
    List<Map<String, dynamic>> maps = await db.rawQuery(query);

    List<PollData> pollList = [];
    for (var poll in maps) {
      pollList.add(PollData.fromLocalDB(
          poll, await PollOption.getOptionsOfPoll(poll[PollData.columnPollId])));
    }
    return pollList;
  }

  static Future<PollData> getOne(int pollid) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Get the Dog from the database.
    final List<Map<String, dynamic>> maps = await db.query(
      PollData.tablename,
      where: "${PollData.columnPollId} = ?",
      whereArgs: [pollid],
    );

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    List<PollData> polls = List.generate(maps.length, (i) {
      return PollData.fromJson(maps[i]);
    });

    if (polls.isNotEmpty)
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
      where: "${PollData.columnPollId} = ?",
      whereArgs: [pollid],
    );

    await PollOption.delete(pollid);
  }
}

class PollOption {
  static final String tablename = 'polloptions';
  static final String columnPollId = 'pollid';
  static final String columnOptionIndex = 'optionindex';
  static final String columnDesc = 'desc';
  static final String columnOpenVotes = 'openVotes';
  static final String columnSecretVotes = 'secretVotes';

  int pollid;
  int optionindex;
  String desc;
  int openVotes;
  int secretVotes;

  PollOption({
    this.pollid,
    this.optionindex,
    this.desc,
    this.openVotes,
    this.secretVotes,
  });

  factory PollOption.fromJson(Map<String, dynamic> json, {int pollid}) =>
      new PollOption(
        pollid: pollid ?? json[pollid],
        optionindex: json[PollOption.columnOptionIndex],
        desc: json[PollOption.columnDesc] ?? '',
        openVotes: json[PollOption.columnOpenVotes] ?? 0,
        secretVotes: json[PollOption.columnSecretVotes] ?? 0,
      );

  Map<String, dynamic> toJsonForServer() => {
        PollOption.columnOptionIndex: optionindex,
        PollOption.columnDesc: desc,
        PollOption.columnOpenVotes: openVotes ?? 0,
        PollOption.columnSecretVotes: secretVotes ?? 0,
      };

  Map<String, dynamic> toJson() => {
        PollOption.columnPollId: pollid,
        PollOption.columnOptionIndex: optionindex,
        PollOption.columnDesc: desc,
        PollOption.columnOpenVotes: openVotes,
        PollOption.columnSecretVotes: secretVotes,
      };

  static Future<void> createTable(Database db) async {
    // Create the grouppoll table
    await db.execute('''CREATE TABLE ${PollOption.tablename}(
          ${PollOption.columnPollId} INTEGER, 
          ${PollOption.columnOptionIndex} INTEGER DEFAULT -1,
          ${PollOption.columnDesc} TEXT,
          ${PollOption.columnOpenVotes} INTEGER DEFAULT 0,
          ${PollOption.columnSecretVotes} INTEGER DEFAULT 0,
          PRIMARY KEY (${PollOption.columnPollId}, ${PollOption.columnOptionIndex})
          FOREIGN KEY (${PollOption.columnPollId}) 
          REFERENCES ${PollData.tablename}(${PollData.columnPollId}) 
          ON DELETE CASCADE
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
        .query(PollOption.tablename, where: '${PollOption.columnPollId} = ?', whereArgs: [pollid]);

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
      where: "${PollOption.columnPollId} = ? AND ${PollOption.columnOptionIndex} = ?",
      whereArgs: [data.pollid, data.optionindex],
    );
  }

  static Future<void> delete(int pollid) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Remove the Dog from the database.
    await db.delete(
      PollOption.tablename,
      where: "${PollOption.columnPollId} = ?",
      whereArgs: [pollid],
    );
  }
}
