import 'package:flutter/material.dart';
import 'package:loudly/providers/pollopts.dart';
import 'package:loudly/providers/vote.dart';

class Poll with ChangeNotifier {
  int pollid;
  String title;
  bool canBeShared;
  bool resultIsPublic;
  int createdBy;
  int createdAt;
  bool voted;

  List<PollOption> _options = [];
  List<int> _groupIds = [];
  List<Vote> _votes = [];

  Poll(
      {@required this.pollid,
      @required this.title,
      @required this.canBeShared,
      @required this.resultIsPublic,
      @required this.createdBy,
      @required this.createdAt,
      @required this.voted});

  List<PollOption> get options {
    return [..._options];
  }

  PollOption getOptionByIndex({@required int index}) {
    if (index < 0) return null;
    return _options[index];
  }

  List<Vote> getVotesOf({@required List<int> userids}) {
    return _votes.where((vote) => userids.contains(vote.votedBy));
  }

  addVote({@required Vote newVote}) {
    Vote vote = _votes.firstWhere((vote) => vote.votedBy == newVote.votedBy,
        orElse: () => null);
    if (vote == null) {
      _votes.add(newVote);
      notifyListeners();
    }
  }

  isInGroup({@required int groupid}) {
    return _groupIds.contains(groupid);
  }

  addToGroup({@required int groupid}) {
    if (!_groupIds.contains(groupid)) {
      _groupIds.add(groupid);
      notifyListeners();
    }
  }

  removeFromGroup({@required int groupid}) {
    if (_groupIds.contains(groupid)) {
      _groupIds.remove(groupid);
      notifyListeners();
    }
  }
}
