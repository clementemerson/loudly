import 'package:flutter/material.dart';
import 'package:loudly/providers/poll.dart';
import 'package:loudly/providers/pollopts.dart';
import 'package:loudly/ui/widgets/consolidatedvotechart.dart';
import 'package:loudly/ui/widgets/opensecretvoteshare.dart';
import 'package:loudly/ui/widgets/pollresultwidgets.dart';
import 'package:loudly/ui/widgets/voteshare.dart';
import 'package:loudly/utilities.dart';
import 'package:provider/provider.dart';

class PollConsolidatedResult extends StatelessWidget {
  static final String consolidated = 'Consolidated';
  static final String votes = 'Votes';

  List<Widget> _getAllOptions(List<PollOption> options) {
    final List<Widget> widgets = [];
    int index = 0;
    for (PollOption option in options) {
      widgets
          .add(_getOptionsField(optionText: option.optionText, index: index));
      index++;
    }
    return widgets;
  }

  Widget _getOptionsField({String optionText, int index}) {
    return Row(
      children: <Widget>[
        new ColorBox(index: index),
        Expanded(
          child: Text(
            optionText,
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Poll poll = Provider.of<Poll>(context);
    return Column(
      children: <Widget>[
        Center(
          child: Text(
            '${PollConsolidatedResult.consolidated} - ${getTotalVotes(poll.options)} ${PollConsolidatedResult.votes}',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ConsolidatedVoteChart(pollResultOptions: poll.options),
            VoteShare(
              pollResultOptions: poll.options,
            ),
          ],
        ),
        Divider(
          color: Colors.blueAccent,
        ),
        OpenSecretVoteShare(
          pollResultOptions: poll.options,
        ),
        SizedBox(
          height: 10.0,
        ),
        Column(
          children: _getAllOptions(poll.options),
        ),
      ],
    );
  }
}