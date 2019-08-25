import 'package:flutter/material.dart';
import 'package:loudly/providers/group_poll_catalog.dart';
import 'package:loudly/providers/group_poll_result_info.dart';
import 'package:loudly/providers/poll_option.dart';

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
  List<Vote> _votes = [];
  GroupPollCatalog _groupPollCatalog;

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

  GroupPollCatalog get groupPollCatalog {
    return _groupPollCatalog;
  }

  set options(List<PollOption> options) {
    _options = options;
  }

  PollOption getOptionByIndex({@required int index}) {
    if (index < 0) return null;
    return _options[index];
  }

  updateOption({@required PollOption option}) {
    PollOption pollOption = _options[option.optionIndex];
    pollOption.updateOpenVotes(noOfVotes: option.openVotes);
    pollOption.updateSecretVotes(noOfVotes: option.secretVotes);
    notifyListeners();
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

  bool isInGroup({@required int groupid}) {
    return _groupPollCatalog.isGroupExists(groupid: groupid);
  }

  addToGroup({@required int groupid}) {
    if (_groupPollCatalog.isGroupExists(groupid: groupid) == false) {
      GroupPollResultInfo groupPollInfo = GroupPollResultInfo(
        groupid: groupid,
      );
      List<PollOption> pollOptions = [];
      for (PollOption pollOption in _options) {
        PollOption option = PollOption(
            optionIndex: pollOption.optionIndex,
            optionText: pollOption.optionText,
            openVotes: -1,
            secretVotes: -1);

        pollOptions.add(option);
      }
      groupPollInfo.options = pollOptions;

      _groupPollCatalog.add(groupPollInfo: groupPollInfo);
    }
  }

  removeFromGroup({@required int groupid}) {
    if (_groupPollCatalog.isGroupExists(groupid: groupid) == true) {
      _groupPollCatalog.remove(groupid: groupid);
    }
  }
}
