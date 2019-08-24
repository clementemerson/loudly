import 'package:flutter/material.dart';
import 'package:loudly/providers/pollopts.dart';

class GroupPollResultInfo with ChangeNotifier {
  int groupid;
  List<PollOption> _options = [];

  GroupPollResultInfo({
    @required this.groupid
  });

  List<PollOption> get options {
    return [..._options];
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
}