import 'package:flutter/material.dart';

class PollOption {
  int optionIndex;
  String optionText;
  int openVotes = 0;
  int secretVotes = 0;

  PollOption(
      {@required this.optionIndex,
      @required this.optionText,
      @required this.openVotes,
      @required this.secretVotes});

  updateOpenVotes({@required int noOfVotes}) {
    if (openVotes != noOfVotes) {
      openVotes = noOfVotes;
    }
  }

  updateSecretVotes({@required int noOfVotes}) {
    if (secretVotes != noOfVotes) {
      secretVotes = noOfVotes;
    }
  }
}
