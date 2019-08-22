import 'package:flutter/material.dart';
import 'package:loudly/Models/userinfo.dart';
import 'package:loudly/providers/user.dart';

class UserStore with ChangeNotifier {
  // Create a singleton
  UserStore._() {
    _initUserList();
  }

  static final UserStore store = UserStore._();

  List<User> _users = [];

  List<User> get users {
    return [..._users];
  }

  addUser({@required User newUser}) {
    if (_users.firstWhere((user) => user.userid == newUser.userid,
            orElse: null) ==
        null) {
      _users.add(newUser);
      notifyListeners();
    }
  }

  User findById({@required int id}) {
    return _users.firstWhere((user) => user.userid == id);
  }

  _initUserList() async {
    List<UserInfoModel> groupList = await UserInfoModel.getAll();
    for (UserInfoModel data in groupList) {
      User user = User(
          userid: data.userId,
          displayName: data.name,
          statusMsg: data.statusMsg);

      this.addUser(newUser: user);
    }
  }
}
