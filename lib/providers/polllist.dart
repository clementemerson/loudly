import 'package:flutter/material.dart';
import 'package:loudly/providers/poll.dart';

class PollStore with ChangeNotifier {
  // Create a singleton
  PollStore._();

  static final PollStore store = PollStore._();

  List<Poll> _polls = [];

  List<Poll> get polls {
    return [..._polls];
  }

  addPoll({@required Poll newPoll}) {
    if (_polls.firstWhere((poll) => poll.pollid == newPoll.pollid,
            orElse: null) ==
        null) {
      _polls.add(newPoll);
      notifyListeners();
    }
  }

  Poll findById({@required int pollid}) {
    return _polls.firstWhere((poll) => poll.pollid == pollid);
  }

  List<Poll> pollsCreatedBy({@required int userid}) {
    return _polls.where((poll) => poll.createdBy == userid);
  }
}
