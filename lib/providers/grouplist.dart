import 'package:flutter/material.dart';
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
    return _groups.firstWhere((group) => group.groupid == id);
  }

  _initGroupList() {
    List<PollDataModel> pollList = await PollDataModel.getAll();
    for (PollDataModel pollData in pollList) {
      Poll poll = Poll(
          pollid: pollData.pollid,
          title: pollData.title,
          canBeShared: pollData.canBeShared,
          resultIsPublic: pollData.resultIsPublic,
          createdAt: pollData.createdAt,
          createdBy: pollData.createdBy,
          voted: pollData.voted);

      this.addPoll(newPoll: poll);
    }
  }
}
