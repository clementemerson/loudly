import 'dart:core';

import 'package:flutter/material.dart';
import 'package:loudly/providers/poll.dart';

import 'package:loudly/project_enums.dart';
import 'package:loudly/providers/poll_store.dart';
import 'package:loudly/ui/globals.dart';
import 'package:loudly/ui/widgets/poll_tile.dart';

import 'package:provider/provider.dart';

class PollList extends StatelessWidget {
  final PollListType pollListType;
  final int groupId;

  PollList({@required this.pollListType, this.groupId});

  @override
  Widget build(BuildContext context) {
    final pollStore = Provider.of<PollStore>(context);
    List<Poll> pollList = [];

    switch (pollListType) {
      case PollListType.All:
        pollList = pollStore.polls;
        break;
      case PollListType.Group:
        pollList = pollStore.pollsInGroup(groupid: groupId);
        break;
      case PollListType.User:
        pollList = pollStore.pollsCreatedBy(userid: Globals.selfUserId);
        break;
    }

    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
        height: 4.0,
        color: Colors.grey,
      ),
      itemCount: pollList.length,
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        value: pollList[index],
        child: PollTile(),
      ),
    );
  }
}
