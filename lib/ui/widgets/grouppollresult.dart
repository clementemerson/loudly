import 'package:flutter/material.dart';
import 'package:loudly/providers/group_poll_result_info.dart';
import 'package:loudly/providers/group_store.dart';
import 'package:loudly/ui/widgets/consolidatedvotechart.dart';
import 'package:loudly/ui/widgets/voteshare.dart';
import 'package:loudly/utilities.dart';
import 'package:provider/provider.dart';

class GroupPollResult extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final groupPollResult = Provider.of<GroupPollResultInfo>(context);
    return Column(children: <Widget>[
      Center(
        child: Text(
          GroupStore.store.findById(id: groupPollResult.groupid).title +
              ' - ' +
              getTotalVotes(groupPollResult.options).toString(),
          style: TextStyle(fontSize: 16.0),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ConsolidatedVoteChart(
            pollResultOptions: groupPollResult.options,
          ),
          VoteShare(
            pollResultOptions: groupPollResult.options,
          ),
        ],
      ),
    ]);
  }
}
