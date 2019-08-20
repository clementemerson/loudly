import 'package:flutter/material.dart';

class Vote {
  int optionIndex;
  int votedBy;
  int votedAt;

  Vote({
    @required this.optionIndex,
    @required this.votedBy,
    @required this.votedAt
  });
}