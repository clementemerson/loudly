import 'package:flutter/material.dart';
import 'package:loudly/providers/poll.dart';
import 'package:loudly/providers/poll_store.dart';
import 'package:loudly/providers/user.dart';
import 'package:loudly/providers/user_store.dart';

class Group with ChangeNotifier {
  int groupid;
  String title;
  String desc;
  int createdBy;
  int createdAt;

  Group(
      {@required this.groupid,
      @required this.title,
      @required this.desc,
      @required this.createdBy,
      @required this.createdAt});

  updateTitle({@required String title}) {
    this.title = title;
    notifyListeners();
  }

  updateDescription({@required String desc}) {
    this.desc = desc;
    notifyListeners();
  }

  List<User> get users {
    return UserStore.store.users
        .where((user) => user.isInGroup(groupid: this.groupid));
  }

  addUser({@required int userid}) {
    User user = UserStore.store.users
        .firstWhere((user) => user.userid == userid, orElse: () => null);
    if (user != null) {
      if (user.addToGroup(groupid: this.groupid) == true) notifyListeners();
    }
  }

  removeUser({@required int userid}) {
    User user = UserStore.store.users
        .firstWhere((user) => user.userid == userid, orElse: () => null);
    if (user != null) {
      if (user.removeFromGroup(groupid: this.groupid) == true)
        notifyListeners();
    }
  }

  List<Poll> get polls {
    return PollStore.store.polls
        .where((poll) => poll.isInGroup(groupid: this.groupid));
  }

  addPoll({@required int pollid}) {
    Poll poll = PollStore.store.polls
        .firstWhere((poll) => poll.pollid == pollid, orElse: () => null);
    if (poll != null) {
      if (poll.addToGroup(groupid: this.groupid) == true) notifyListeners();
    }
  }

  removePoll({@required int pollid}) {
    Poll poll = PollStore.store.polls
        .firstWhere((poll) => poll.pollid == pollid, orElse: () => null);
    if (poll != null) {
      if (poll.removeFromGroup(groupid: this.groupid) == true)
        notifyListeners();
    }
  }
}
