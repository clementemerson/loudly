import 'package:flutter/material.dart';
import 'package:loudly/providers/poll.dart';

class PollList with ChangeNotifier {
  List<Poll> _polls = [];

  List<Poll> get polls {
    return [..._polls];
  }

  addPoll({@required Poll poll}) {
    _polls.add(poll);
    notifyListeners();
  }

  Poll findById({@required int id}) {
    return _polls.firstWhere((poll) => poll.pollid == id);
  }
}
