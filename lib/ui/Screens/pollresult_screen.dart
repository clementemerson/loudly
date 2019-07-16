import 'package:flutter/material.dart';

import 'package:loudly/models/polldata.dart';
import 'package:loudly/project_settings.dart';
import 'package:loudly/project_styles.dart';
import 'package:loudly/ui/Lists/pollresults_groups.dart';
import 'package:loudly/ui/widgets/consolidatedvotechart.dart';
import 'package:loudly/ui/widgets/opensecretvoteshare.dart';
import 'package:loudly/ui/widgets/pollresultwidgets.dart';
import 'package:loudly/ui/widgets/voteshare.dart';
import 'package:loudly/ui/widgets/votetitle.dart';

class PollResultScreen extends StatefulWidget {
  static final String id = 'pollresult_screen';
  static final String appBarTitle = 'Poll Result';
  static final String resultsFromGroup = 'Poll results from your groups';
  static final String consolidated = 'Consolidated';
  static final String votes = 'Votes';

  @override
  _PollResultScreenState createState() => _PollResultScreenState();
}

class _PollResultScreenState extends State<PollResultScreen> {
  PollData pollData;

  AppBar _getAppBar() {
    return AppBar(title: Text(PollResultScreen.appBarTitle), actions: <Widget>[
      IconButton(
        icon: Icon(
          Icons.reply,
          textDirection: TextDirection.rtl,
        ),
        onPressed: () {},
      )
    ]);
  }

  int getTotalVotes(List<PollOption> options) {
    int sum = 0;
    for (PollOption option in options) {
      sum += option.openVotes + option.secretVotes;
    }
    return sum;
  }

  List<Widget> _getAllOptions() {
    final List<Widget> widgets = [];
    int index = 0;
    for (PollOption option in pollData.options) {
      widgets.add(_getOptionsField(optionText: option.desc, index: index));
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

  Widget _getPollResultsFromGroups() {
    return GroupPollResults(pollId: pollData.pollid);
  }

  @override
  Widget build(BuildContext context) {
    pollData = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: _getAppBar(),
      body: Container(
        padding: const EdgeInsets.only(
          left: 8.0,
          right: 8.0,
        ),
        child: ListView(
          children: [
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: <Widget>[
                Icon(
                  projectIcon,
                  size: kIcon_Small,
                  color: Colors.blue,
                ),
                Expanded(
                  child: VoteTitle(
                    title: pollData.title,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Divider(
              color: Colors.blueAccent,
            ),
            Center(
              child: Text(
                '${PollResultScreen.consolidated} - ${getTotalVotes(pollData.options)} ${PollResultScreen.votes}',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ConsolidatedVoteChart(pollResultOptions: pollData.options),
                VoteShare(
                  pollResultOptions: pollData.options,
                ),
              ],
            ),
            Divider(
              color: Colors.blueAccent,
            ),
            OpenSecretVoteShare(
              pollResultOptions: pollData.options,
            ),
            SizedBox(
              height: 10.0,
            ),
            Column(
              children: _getAllOptions(),
            ),
            Divider(
              color: Colors.blueAccent,
            ),
            Center(
              child: Text(
                PollResultScreen.resultsFromGroup,
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            _getPollResultsFromGroups(),
          ],
        ),
      ),
    );
  }
}
