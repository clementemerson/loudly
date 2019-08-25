import 'dart:io';
import 'package:loudly/models/group_info_model.dart';
import 'package:loudly/models/group_poll_model.dart';
import 'package:loudly/models/group_poll_result_model.dart';
import 'package:loudly/models/group_user_model.dart';
import 'package:loudly/models/poll_data_model.dart';
import 'package:loudly/models/user_info_model.dart';
import 'package:loudly/models/user_poll_model.dart';
import 'package:loudly/models/user_vote_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  // Create a singleton
  DBProvider._();

  static final DBProvider db = DBProvider._();
  static final String dbFile = 'loud01.db';
  Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await initDB();
    return _database;
  }

  initDB() async {
    // Get the location of our app directory. This is where files for our app,
    // and only our app, are stored. Files in this directory are deleted
    // when the app is deleted.
    Directory documentsDir = await getApplicationDocumentsDirectory();
    String path = join(documentsDir.path, DBProvider.dbFile);
    print(path);

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) async {},
      onCreate: (Database db, int version) async {
        var baseTablesCreation = <Future>[
          UserInfoModel.createTable(db), //users table
          GroupInfoModel.createTable(db), //groupinfo table
          PollDataModel.createTable(db), //polldata table
          PollOptionModel.createTable(db), //polloption table
        ];
        await Future.wait(baseTablesCreation);

        var dataTablesCreation = <Future>[
          GroupUserModel.createTable(db), //groupuser table
          GroupPollModel.createTable(db), //grouppoll table
          UserPollModel.createTable(db), //userpoll table
          GroupPollResultModel.createTable(db), //grouppollresult table
          UserVote.createTable(db), //uservote table
        ];
        await Future.wait(dataTablesCreation);
      },
    );
  }
}
