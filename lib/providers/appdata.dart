import 'package:flutter/foundation.dart';
import 'package:loudly/providers/grouplist.dart';
import 'package:loudly/providers/polllist.dart';
import 'package:loudly/providers/userlist.dart';

class AppData with ChangeNotifier {
  PollList pollList = PollList();
  GroupList groupList = GroupList();
  UserList userList = UserList();

  // Create a singleton
  AppData._();

  static final AppData appData = AppData._();
}
