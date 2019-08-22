import 'dart:io';
import 'package:loudly/models/groupinfo.dart';
import 'package:loudly/models/groupuser.dart';
import 'package:loudly/models/userinfo.dart';
import 'package:loudly/models/userpoll.dart';
import 'package:loudly/models/grouppoll.dart';
import 'package:loudly/models/grouppollresult.dart';
import 'package:loudly/models/polldata.dart';
import 'package:loudly/models/uservote.dart';
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
          UserInfo.createTable(db), //users table
          GroupInfo.createTable(db), //groupinfo table
          PollDataModel.createTable(db), //polldata table
          PollOptionModel.createTable(db), //polloption table
        ];
        await Future.wait(baseTablesCreation);

        var dataTablesCreation = <Future>[
          GroupUser.createTable(db),  //groupuser table
          GroupPoll.createTable(db),  //grouppoll table
          UserPoll.createTable(db), //userpoll table
          GroupPollResult.createTable(db),  //grouppollresult table
          UserVote.createTable(db), //uservote table
        ];
        await Future.wait(dataTablesCreation);
      },
    );
  }
}
