// To parse this JSON data, do
//
//     final pollData = pollDataFromJson(jsonString);

import 'dart:convert';

import 'package:loudly/data/database.dart';
import 'package:loudly/providers/poll.dart';
import 'package:loudly/providers/poll_option.dart';
import 'package:loudly/providers/poll_store.dart';
import 'package:sqflite/sqflite.dart';

PollDataModel pollDataFromJson(Map<String, dynamic> map) =>
    PollDataModel.fromJson(map);

List<PollDataModel> pollInfoFromList(List<dynamic> list) {
  List<PollDataModel> pollDataList = List<PollDataModel>();
  for (var item in list) {
    PollDataModel pollData = PollDataModel.fromJson(item);
    if (pollData != null) pollDataList.add(pollData);
  }
  return pollDataList;
}

String pollDataToJson(PollDataModel data) => json.encode(data.toJson());

List<dynamic> pollOptionListToJson(List<PollOptionModel> list) =>
    new List<dynamic>.from(list.map((x) => x.toJsonForServer()));

List<PollOptionModel> pollOptionFromList(List<dynamic> list, int pollid) {
  List<PollOptionModel> pollOptions = List<PollOptionModel>();
  for (String x in list) {
    pollOptions.add(PollOptionModel.fromJson(json.decode(x), pollid: pollid));
  }
  return pollOptions;
}

//json.encode(data.toJson());

class PollDataModel {
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
  List<PollOptionModel> options;
  bool canBeShared;
  bool resultIsPublic;
  int createdBy;
  int createdAt;
  bool voted;

  PollDataModel(
      {this.pollid,
      this.title,
      this.options,
      this.canBeShared,
      this.resultIsPublic,
      this.createdBy,
      this.createdAt,
      this.voted});

  factory PollDataModel.fromJson(Map<String, dynamic> json) {
    try {
      return PollDataModel(
        pollid: json[PollDataModel.columnPollId],
        title: json[PollDataModel.columnTitle],
        options: new List<PollOptionModel>.from(json[PollDataModel.jsonOptions]
            .map((x) => PollOptionModel.fromJson(x,
                pollid: json[PollDataModel.columnPollId]))),
        canBeShared: json[PollDataModel.columnCanBeShared] == 0 ? false : true,
        resultIsPublic:
            json[PollDataModel.columnResultIsPublic] == 0 ? false : true,
        createdBy: json[PollDataModel.columnCreatedBy],
        createdAt: json[PollDataModel.columnCreatedAt],
        voted: json[PollDataModel.columnVoted] ?? false,
      );
    } catch (err) {
      return null;
    }
  }

  factory PollDataModel.fromLocalDB(
          Map<String, dynamic> json, List<PollOptionModel> pollOptions) =>
      new PollDataModel(
        pollid: json[PollDataModel.columnPollId],
        title: json[PollDataModel.columnTitle],
        options: pollOptions,
        canBeShared: json[PollDataModel.columnCanBeShared] == 0 ? false : true,
        resultIsPublic:
            json[PollDataModel.columnResultIsPublic] == 0 ? false : true,
        createdBy: json[PollDataModel.columnCreatedBy],
        createdAt: json[PollDataModel.columnCreatedAt],
        voted: json[PollDataModel.columnVoted] == 0 ? false : true,
      );

  Map<String, dynamic> toJson() => {
        PollDataModel.columnPollId: pollid,
        PollDataModel.columnTitle: title,
        //"options": new List<dynamic>.from(options.map((x) => x.toJson())),
        PollDataModel.columnCanBeShared: canBeShared,
        PollDataModel.columnResultIsPublic: resultIsPublic,
        PollDataModel.columnCreatedBy: createdBy,
        PollDataModel.columnCreatedAt: createdAt,
        PollDataModel.columnVoted: voted,
      };

  static Future<void> createTable(Database db) async {
    // Create the grouppoll table
    await db.execute('''CREATE TABLE ${PollDataModel.tablename}(
          ${PollDataModel.columnPollId} INTEGER PRIMARY KEY, 
          ${PollDataModel.columnTitle} TEXT,
          ${PollDataModel.columnCanBeShared} INTEGER DEFAULT 0,
          ${PollDataModel.columnResultIsPublic} INTEGER DEFAULT 0,
          ${PollDataModel.columnCreatedBy} INTEGER DEFAULT 0,
          ${PollDataModel.columnCreatedAt} INTEGER DEFAULT 0,
          ${PollDataModel.columnVoted} INTEGER DEFAULT 0
        )''');
  }

  static Future<void> insert(PollDataModel data) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same Dog is inserted
    // multiple times, it replaces the previous data.
    await db.insert(
      PollDataModel.tablename,
      data.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    List<PollOption> pollOptions = [];
    data.options.forEach((option) async {
      await PollOptionModel.insert(option);
      PollOption pollOption = PollOption(
          optionIndex: option.optionindex,
          optionText: option.desc,
          openVotes: option.openVotes,
          secretVotes: option.secretVotes);
      pollOptions.add(pollOption);
    });

    //construct Poll Object
    Poll poll = Poll(
        pollid: data.pollid,
        title: data.title,
        canBeShared: data.canBeShared,
        resultIsPublic: data.resultIsPublic,
        createdAt: data.createdAt,
        createdBy: data.createdBy,
        voted: data.voted);

    poll.options = pollOptions;

    //add poll object to pollstore
    PollStore.store.addPoll(newPoll: poll);
  }

  static Future<List<PollDataModel>> getAll() async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Query the table for all The dogs.
    List<Map<String, dynamic>> maps = await db.query(PollDataModel.tablename,
        orderBy: '${PollDataModel.columnCreatedAt} DESC');

    List<PollDataModel> pollList = [];
    for (var poll in maps) {
      pollList.add(PollDataModel.fromLocalDB(
          poll,
          await PollOptionModel.getOptionsOfPoll(
              poll[PollDataModel.columnPollId])));
    }

    return pollList;
  }

  static Future<void> delete(int pollid) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Remove the Dog from the database.
    await db.delete(
      PollDataModel.tablename,
      where: "${PollDataModel.columnPollId} = ?",
      whereArgs: [pollid],
    );

    await PollOptionModel.delete(pollid);
  }
}

class PollOptionModel {
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

  PollOptionModel({
    this.pollid,
    this.optionindex,
    this.desc,
    this.openVotes,
    this.secretVotes,
  });

  factory PollOptionModel.fromJson(Map<String, dynamic> json, {int pollid}) =>
      new PollOptionModel(
        pollid: pollid ?? json[pollid],
        optionindex: json[PollOptionModel.columnOptionIndex],
        desc: json[PollOptionModel.columnDesc] ?? '',
        openVotes: json[PollOptionModel.columnOpenVotes] ?? 0,
        secretVotes: json[PollOptionModel.columnSecretVotes] ?? 0,
      );

  Map<String, dynamic> toJsonForServer() => {
        PollOptionModel.columnOptionIndex: optionindex,
        PollOptionModel.columnDesc: desc,
      };

  Map<String, dynamic> toJson() => {
        PollOptionModel.columnPollId: pollid,
        PollOptionModel.columnOptionIndex: optionindex,
        PollOptionModel.columnDesc: desc,
        PollOptionModel.columnOpenVotes: openVotes,
        PollOptionModel.columnSecretVotes: secretVotes,
      };

  static Future<void> createTable(Database db) async {
    // Create the grouppoll table
    await db.execute('''CREATE TABLE ${PollOptionModel.tablename}(
          ${PollOptionModel.columnPollId} INTEGER, 
          ${PollOptionModel.columnOptionIndex} INTEGER DEFAULT -1,
          ${PollOptionModel.columnDesc} TEXT,
          ${PollOptionModel.columnOpenVotes} INTEGER DEFAULT 0,
          ${PollOptionModel.columnSecretVotes} INTEGER DEFAULT 0,
          PRIMARY KEY (${PollOptionModel.columnPollId}, ${PollOptionModel.columnOptionIndex})
          FOREIGN KEY (${PollOptionModel.columnPollId}) 
          REFERENCES ${PollDataModel.tablename}(${PollDataModel.columnPollId}) 
          ON DELETE CASCADE
        )''');
  }

  static Future<void> insert(PollOptionModel data) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same groupInfo is inserted
    // multiple times, it replaces the previous data.
    await db.insert(
      PollOptionModel.tablename,
      data.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<PollOptionModel>> getOptionsOfPoll(int pollid) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Query the table for all The dogs.
    final List<Map<String, dynamic>> maps = await db.query(
        PollOptionModel.tablename,
        where: '${PollOptionModel.columnPollId} = ?',
        whereArgs: [pollid]);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return PollOptionModel.fromJson(maps[i]);
    });
  }

  static Future<void> update(PollOptionModel data) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Update the given Dog.
    await db.update(
      PollOptionModel.tablename,
      data.toJson(),
      where:
          "${PollOptionModel.columnPollId} = ? AND ${PollOptionModel.columnOptionIndex} = ?",
      whereArgs: [data.pollid, data.optionindex],
    );

    Poll poll = PollStore.store.findById(pollid: data.pollid);
    poll.updateOption(
        option: PollOption(
            optionIndex: data.optionindex,
            optionText: data.desc,
            openVotes: data.openVotes,
            secretVotes: data.secretVotes));
  }

  static Future<void> delete(int pollid) async {
    // Get a reference to the database.
    final Database db = await DBProvider.db.database;

    // Remove the Dog from the database.
    await db.delete(
      PollOptionModel.tablename,
      where: "${PollOptionModel.columnPollId} = ?",
      whereArgs: [pollid],
    );
  }
}
