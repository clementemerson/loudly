import 'package:flutter/material.dart';
import 'package:loudly/providers/group.dart';
import 'package:loudly/providers/group_store.dart';

class User with ChangeNotifier {
  int userid;
  String displayName;
  String statusMsg;
  List<int> _groupIds = [];

  User(
      {@required this.userid,
      @required this.displayName,
      @required this.statusMsg});

  List<Group> get groups {
    return GroupStore.store.groups
        .where((group) => _groupIds.contains(group.groupid));
  }

  isInGroup({@required int groupid}) {
    return _groupIds.contains(groupid);
  }

  bool addToGroup({@required int groupid}) {
    if (!_groupIds.contains(groupid)) {
      _groupIds.add(groupid);
      notifyListeners();
      return true;
    }
    return false;
  }

  bool removeFromGroup({@required int groupid}) {
    if (_groupIds.contains(groupid)) {
      _groupIds.remove(groupid);
      notifyListeners();
      return true;
    }
    return false;
  }
}
