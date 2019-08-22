import 'dart:core';

import 'package:flutter/material.dart';

import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:loudly/providers/polllist.dart';
import 'package:loudly/providers/pollopts.dart';
import 'package:loudly/ui/Screens/pollresult_screen.dart';
import 'package:loudly/ui/Screens/pollvote_screen.dart';

import 'package:loudly/project_enums.dart';
import 'package:loudly/project_styles.dart';

import 'package:provider/provider.dart';

class PollList extends StatefulWidget {
  final PollListType pollListType;
  final int groupId;

  PollList({@required this.pollListType, this.groupId});

  @override
  _PollListState createState() => _PollListState();
}

class _PollListState extends State<PollList> {

  @override
  void initState() {
    //_getPollData();

    super.initState();
  }

/// Prepares chart info
  _getChartData(List<PollOption> options) {
    List<CircularSegmentEntry> entries = [];

    int colorIndex = 0;
    for (PollOption option in options) {
      entries.add(new CircularSegmentEntry(
          option.openVotes.toDouble() + option.secretVotes.toDouble(),
          kGetOptionColor(colorIndex)));
      colorIndex++;
    }

    return <CircularStackEntry>[
      new CircularStackEntry(entries),
    ];
  }

  List<int> getVoteList(List<dynamic> receivedVoteList) {
    List<int> votes = [];
    for (var receivedVotes in receivedVoteList) {
      votes.add(receivedVotes);
    }
    return votes;
  }

/// Calculates the total no of votes casted
  int _getTotalVotes(List<PollOption> options) {
    int sum = 0;
    for (PollOption option in options) {
      sum += option.openVotes + option.secretVotes;
    }
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    final pollStore = Provider.of<PollStore>(context);
    final pollList = pollStore.polls;

    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
        height: 4.0,
        color: Colors.grey,
      ),
      itemCount: pollList.length,
      itemBuilder: (context, index) {
        return ListTile(
          contentPadding: EdgeInsets.only(left: 10.0),
          title: Text(
            '${pollList[index].title}',
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            '${pollList[index].createdBy} - ${_getTotalVotes(pollList[index].options)} Votes',
          ),
          trailing: pollList[index].voted == true
              ? AnimatedCircularChart(
                  size: const Size(80.0, 80.0),
                  initialChartData: _getChartData(pollList[index].options),
                  chartType: CircularChartType.Pie,
                  duration: Duration(
                    seconds: 1,
                  ),
                )
              : Container(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    'Vote',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
          onTap: () {
            pollList[index].voted == true
                ? Navigator.pushNamed(context, PollResultScreen.id,
                    arguments: pollList[index])
                : Navigator.pushNamed(context, PollVoteScreen.id,
                    arguments: pollList[index]);
          },
        );
      },
    );
  }
}
