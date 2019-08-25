import 'package:flutter/material.dart';
import 'package:loudly/models/group_info_model.dart';
import 'package:loudly/providers/group.dart';

class GroupStore with ChangeNotifier {
  // Create a singleton
  GroupStore._() {
    _initGroupList();
  }

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
    return _groups.firstWhere((group) => group.groupid == id, orElse: () => null);
  }

  _initGroupList() async {
    List<GroupInfoModel> groupList = await GroupInfoModel.getAll();
    for (GroupInfoModel data in groupList) {
      Group group = Group(
          groupid: data.groupid,
          title: data.name,
          desc: data.desc,
          createdBy: data.createdBy,
          createdAt: data.createdAt);

      this.addGroup(group: group);
    }
  }
}
