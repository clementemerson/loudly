import 'package:flutter/cupertino.dart';
import 'package:loudly/providers/poll.dart';
import 'package:loudly/providers/user.dart';

class Group with ChangeNotifier {
  int groupid;
  String title;
  String desc;
  int createdBy;
  int createdAt;

  List<Poll> _polls = [];
  List<User> _users = [];

  Group(
      {@required this.groupid,
      @required this.title,
      @required this.desc,
      @required this.createdBy,
      @required this.createdAt});

  List<Poll> get polls {
    return [..._polls];
  }

  addPoll({@required Poll poll}) {
    _polls.add(poll);
    notifyListeners();
  }

  Poll findPollById({@required int id}) {
    return _polls.firstWhere((poll) => poll.pollid == id);
  }

  List<User> get users {
    return [..._users];
  }

  addUser({@required User user}) {
    _users.add(user);
    notifyListeners();
  }

  User findUserById({@required int id}) {
    return _users.firstWhere((user) => user.userid == id);
  }
}
