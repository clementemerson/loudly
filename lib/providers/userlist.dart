import 'package:flutter/material.dart';
import 'package:loudly/providers/user.dart';

class UserList with ChangeNotifier {
  List<User> _users = [];

  List<User> get users {
    return [..._users];
  }

  addUser({@required User user}) {
    _users.add(user);
    notifyListeners();
  }

  User findById({@required int id}) {
    return _users.firstWhere((user) => user.userid == id);
  }
}
