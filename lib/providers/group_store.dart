import 'package:flutter/material.dart';
import 'package:loudly/models/group_info_model.dart';
import 'package:loudly/models/group_poll_model.dart';
import 'package:loudly/providers/group.dart';

class GroupStore with ChangeNotifier {
  // Create a singleton
  GroupStore._() {
    _groups = [];
  }

  static final GroupStore store = GroupStore._();

  List<Group> _groups;

  List<Group> get groups {
    return [..._groups];
  }

  addGroup({@required Group newGroup}) {
    if (_groups.firstWhere((group) => group.groupid == newGroup.groupid,
            orElse: () => null) ==
        null) {
      _groups.insert(0, newGroup);
      notifyListeners();
    }
  }

  Group findById({@required int id}) {
    return _groups.firstWhere((group) => group.groupid == id,
        orElse: () => null);
  }

  List<Group> searchByText(searchText) {
    return _groups
        .where((group) =>
            group.title.toLowerCase().contains(searchText.toLowerCase()))
        .toList();
  }

  init() async {
    _initGroupList();
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

      this.addGroup(newGroup: group);
      _initGroupPolls(data.groupid);
    }
  }

  _initGroupPolls(int groupid) async {
    List<int> pollids = await GroupPollModel.getPollIdsByGroup(groupid);
    print('_initGroupPolls');
    if (pollids.length == 0) return;

print(pollids);
    Group group = GroupStore.store.findById(id: groupid);
    for (var pollid in pollids) {
      group.addPoll(pollid: pollid);
    }
  }
}
