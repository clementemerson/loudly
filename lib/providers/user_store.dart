import 'package:flutter/material.dart';
import 'package:loudly/models/user_info_model.dart';
import 'package:loudly/providers/user.dart';
import 'package:loudly/resources/phone_services/contacts_helper.dart';

class UserStore with ChangeNotifier {
  // Create a singleton
  UserStore._() {
    _users = [];
  }

  static final UserStore store = UserStore._();

  List<User> _users = [];

  List<User> get users {
    return [..._users];
  }

  addUser({@required User newUser}) {
    if (_users.firstWhere((user) => user.userid == newUser.userid,
            orElse: () => null) ==
        null) {
      _users.add(newUser);
      notifyListeners();
    }
  }

  User findById({@required int id}) {
    return _users.firstWhere((user) => user.userid == id, orElse: () => null);
  }

  List<User> searchByText(String searchText) {
    String lowerCaseText = searchText.toLowerCase();
    return _users.where((user) {
      if (user.phoneName != null) {
        return user.phoneName.toLowerCase().contains(lowerCaseText);
      } else {
        return user.displayName
            .toLowerCase()
            .contains(searchText.toLowerCase());
      }
    }).toList();
  }

  init() async {
    _initUserList();
  }

  _initUserList() async {
    List<UserInfoModel> groupList = await UserInfoModel.getAll();
    Map<String, PhoneContact> contacts =
        await ContactsHelper.updatePhoneContacts();
    for (UserInfoModel data in groupList) {
      User user = User(
          userid: data.userId,
          displayName: data.name,
          statusMsg: data.statusMsg,
          phoneNumber: data.phoneNumber);
      user.phoneName = contacts.isNotEmpty
          ? ContactsHelper.getUserNameInPhone(user.phoneNumber)
          : null;

      this.addUser(newUser: user);
    }
  }
}
