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
    String path = join(documentsDir.path, 'loud16.db');
    print(path);

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) async {},
      onCreate: (Database db, int version) async {

        var baseTablesCreation = <Future>[];
        // Create the users table
        baseTablesCreation.add(UserInfo.createTable(db));
        // Create the groupinfo table
        baseTablesCreation.add(GroupInfo.createTable(db));
        // Create the polldata table
        baseTablesCreation.add(PollData.createTable(db));
        // Create the polloptions table
        baseTablesCreation.add(PollOption.createTable(db));

        await Future.wait(baseTablesCreation);

        // // Create the users table
        // await UserInfo.createTable(db);

        // // Create the groupinfo table
        // await GroupInfo.createTable(db);

        // // Create the polldata table
        // await PollData.createTable(db);

        // // Create the polloptions table
        // await PollOption.createTable(db);

        var dataTablesCreation = <Future>[];
        // Create the groupusers table
        dataTablesCreation.add(GroupUser.createTable(db));
        // Create the grouppoll table
        dataTablesCreation.add(GroupPoll.createTable(db));
        // Create the userpolls table
        dataTablesCreation.add(UserPoll.createTable(db));
        // Create the grouppollresult table
        dataTablesCreation.add(GroupPollResult.createTable(db));
        // Create the uservote table
        dataTablesCreation.add(UserVote.createTable(db)); 

        await Future.wait(dataTablesCreation);   


        // // Create the groupusers table
        // await GroupUser.createTable(db);

        // // Create the grouppoll table
        // await GroupPoll.createTable(db);

        // // Create the userpolls table
        // await UserPoll.createTable(db);

        // // Create the grouppollresult table
        // await GroupPollResult.createTable(db);

        // // Create the uservote table
        // await UserVote.createTable(db);        
      },
    );
  }
}
