import 'package:flutter/material.dart';
import 'package:loudly/providers/grouplist.dart';
import 'package:loudly/providers/polllist.dart';
import 'package:loudly/providers/userlist.dart';

class AppData with ChangeNotifier {
  PollStore pollList = PollStore.store;
  GroupStore groupList = GroupStore.store;
  UserStore userList = UserStore.store;

  // Create a singleton
  AppData._();

  static final AppData appData = AppData._();
}
