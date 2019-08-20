import 'package:flutter/material.dart';
import 'package:loudly/providers/group.dart';

class GroupStore with ChangeNotifier {
    // Create a singleton
  GroupStore._();

  static final GroupStore store = GroupStore._();

  List<Group> _groups = [];

  List<Group> get groups {
    return [..._groups];
  }

  addGroup({@required Group group}) {
    _groups.add(group);
    notifyListeners();
  }

  Group findById({@required int id}) {
    return _groups.firstWhere((group) => group.groupid == id);
  }
}
