import 'package:flutter/material.dart';
import 'package:loudly/models/poll_data_model.dart';
import 'package:loudly/providers/poll.dart';
import 'package:loudly/providers/pollopts.dart';

class PollStore with ChangeNotifier {
  // Create a singleton
  PollStore._() {
    _initPollList();
  }

  static final PollStore store = PollStore._();

  List<Poll> _polls = [];

  List<Poll> get polls {
    return [..._polls];
  }

  addPoll({@required Poll newPoll}) {
    if (_polls.firstWhere((poll) => poll.pollid == newPoll.pollid,
            orElse: () => null) ==
        null) {
      _polls.add(newPoll);
      notifyListeners();
    }
  }

  Poll findById({@required int pollid}) {
    return _polls.firstWhere((poll) => poll.pollid == pollid, orElse: () => null);
  }

  List<Poll> pollsCreatedBy({@required int userid}) {
    return _polls.where((poll) => poll.createdBy == userid);
  }

  List<Poll> pollsInGroup({@required int groupid}) {
    return _polls.where((poll) => poll.isInGroup(groupid: groupid));
  }

  _initPollList() async {
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

      List<PollOption> pollOptions = [];
      for (PollOptionModel pollOption in pollData.options) {
        PollOption option = PollOption(
            optionIndex: pollOption.optionindex,
            optionText: pollOption.desc,
            openVotes: pollOption.openVotes,
            secretVotes: pollOption.secretVotes);

        pollOptions.add(option);
      }

      poll.options = pollOptions;

      this.addPoll(newPoll: poll);
    }
  }
}
