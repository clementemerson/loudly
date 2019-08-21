import 'package:flutter/material.dart';

class PollOption with ChangeNotifier {
  int optionIndex;
  String optionText;
  int openVotes = -1;
  int secretVotes = -1;

  PollOption(
      {@required this.optionIndex,
      @required this.optionText,
      @required this.openVotes,
      @required this.secretVotes});

  updateOpenVotes({@required int noOfVotes}) {
    if (openVotes != noOfVotes) {
      openVotes = noOfVotes;
      notifyListeners();
    }
  }

  updateSecretVotes({@required int noOfVotes}) {
    if (secretVotes != noOfVotes) {
      secretVotes = noOfVotes;
      notifyListeners();
    }
  }
}
