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
    String path = join(documentsDir.path, 'loud15.db');
    print(path);

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) async {},
      onCreate: (Database db, int version) async {
        // Create the users table
        await UserInfo.createTable(db);

        // Create the groupinfo table
        await GroupInfo.createTable(db);

        // Create the userpolls table
        await UserPoll.createTable(db);

        // Create the groupusers table
        await GroupUser.createTable(db);

        // Create the polldata table
        await PollData.createTable(db);

        // Create the grouppoll table
        await GroupPoll.createTable(db);

        // Create the grouppollresult table
        await GroupPollResult.createTable(db);

        // Create the uservote table
        await UserVote.createTable(db);

        await PollOption.createTable(db);
      },
    );
  }
}
