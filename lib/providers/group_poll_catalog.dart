import 'package:flutter/material.dart';
import 'package:loudly/providers/group_poll_result_info.dart';

class GroupPollCatalog with ChangeNotifier {
  List<GroupPollResultInfo> _catalog;

  List<GroupPollResultInfo> get pollInfos {
    return [..._catalog];
  }

  bool isGroupExists({@required int groupid}) {
    GroupPollResultInfo groupPollInfo = getGroupPollInfo(groupid: groupid);
    if (groupPollInfo != null) return true;
    return false;
  }

  GroupPollResultInfo getGroupPollInfo({@required int groupid}) {
    GroupPollResultInfo groupPollInfo = _catalog.firstWhere(
        (groupInfo) => groupInfo.groupid == groupid,
        orElse: () => null);
    return groupPollInfo;
  }

  add({@required GroupPollResultInfo groupPollInfo}) {
    if (!isGroupExists(groupid: groupPollInfo.groupid)) {
      _catalog.add(groupPollInfo);
      notifyListeners();
    }
  }

  remove({@required int groupid}) {
    if (isGroupExists(groupid: groupid)) {
      _catalog.remove(getGroupPollInfo(groupid: groupid));
      notifyListeners();
    }
  }
}
