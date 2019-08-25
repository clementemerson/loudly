import 'package:flutter/material.dart';
import 'package:loudly/providers/group_store.dart';
import 'package:loudly/providers/poll_store.dart';
import 'package:loudly/providers/user_store.dart';

class AppData with ChangeNotifier {
  PollStore pollList = PollStore.store;
  GroupStore groupList = GroupStore.store;
  UserStore userList = UserStore.store;

  // Create a singleton
  AppData._();

  static final AppData appData = AppData._();
}
