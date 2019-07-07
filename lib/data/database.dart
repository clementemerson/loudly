import 'dart:io';
import 'package:loudly/Models/groupinfo.dart';
import 'package:loudly/Models/groupuser.dart';
import 'package:loudly/Models/userinfo.dart';
import 'package:loudly/Models/userpoll.dart';
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
    String path = join(documentsDir.path, 'loud3.db');

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

        // // Create the grouppolls table
        // await db.execute('''CREATE TABLE grouppolls(
        //   pollid INTEGER DEFAULT -1, 
        //   groupid INTEGER DEFAULT -1,
        //   sharedby INTEGER DEFAULT -1,
        //   createdAt INTEGER DEFAULT 0,
        //   updatedAt INTEGER DEFAULT 0
        // )''');

        // // Create the groupusers table
        // await db.execute('''CREATE TABLE ${GroupUser.tablename}(
        //   groupid INTEGER DEFAULT -1, 
        //   user_id INTEGER DEFAULT -1,
        //   addedby INTEGER DEFAULT -1,
        //   permission TEXT DEFAULT 'USER',
        //   createdAt INTEGER DEFAULT 0,
        //   updatedAt INTEGER DEFAULT 0
        // )''');

        // // Create the polldata table
        // await db.execute('''CREATE TABLE polldata(
        //   id INTEGER PRIMARY KEY,
        //   title TEXT DEFAULT '', 
        //   resultispublic INTEGER DEFAULT 1,
        //   canbeshared INTEGER DEFAULT 1,
        //   createdby INTEGER DEFAULT -1,
        //   createdAt INTEGER DEFAULT 0,
        //   updatedAt INTEGER DEFAULT 0
        // )''');

        // //Create pollvotes table
        // await db.execute('''CREATE TABLE pollvotes(
        //   pollid INTEGER DEFAULT -1, 
        //   optionindex INTEGER DEFAULT -1,
        //   optiontext TEXT DEFAULT '',
        //   openvotes INTEGER DEFAULT -1,
        //   secretvotes INTEGER DEFAULT -1
        // )''');

        // //Create pollgroupvotes table
        // await db.execute('''CREATE TABLE pollgroupvotes(
        //   pollid INTEGER DEFAULT -1, 
        //   groupid INTEGER DEFAULT -1, 
        //   optionindex INTEGER DEFAULT -1,
        //   optiontext TEXT DEFAULT '',
        //   openvotes INTEGER DEFAULT -1
        // )''');

        // // Create the pollvotedata table
        // await db.execute('''CREATE TABLE pollvotedata(
        //   pollid INTEGER DEFAULT -1, 
        //   user_id INTEGER DEFAULT -1,
        //   optionindex INTEGER DEFAULT -1,
        //   createdAt INTEGER DEFAULT 0,
        //   updatedAt INTEGER DEFAULT 0
        // )''');

        // // Create the pollvoteregister table
        // await db.execute('''CREATE TABLE pollvoteregister(
        //   pollid INTEGER DEFAULT -1, 
        //   user_id INTEGER DEFAULT -1,
        //   votetype INTEGER DEFAULT -1,
        //   createdAt INTEGER DEFAULT 0,
        //   updatedAt INTEGER DEFAULT 0
        // )''');

        

      },
    );
  }
}
