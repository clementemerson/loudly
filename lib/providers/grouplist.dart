

import 'package:flutter/material.dart';
import 'package:loudly/providers/group.dart';

class GroupList with ChangeNotifier {
  List<Group> _groups = [];

  List<Group> get polls {
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