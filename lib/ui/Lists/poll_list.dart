import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:loudly/ui/Screens/pollresult_screen.dart';
import 'package:loudly/ui/Screens/pollvote_screen.dart';

import 'package:loudly/project_enums.dart';
import 'package:loudly/project_styles.dart';

import 'package:loudly/models/polldata.dart';

class PollList extends StatefulWidget {
  final PollListType pollListType;
  final String groupId;

  PollList({@required this.pollListType, this.groupId});

  @override
  _PollListState createState() => _PollListState();
}

class _PollListState extends State<PollList> {
  List<PollData> _pollList = [];

  @override
  void initState() {
    getPollData();

    super.initState();
  }

  getChartData(List<PollOption> options) {
    List<CircularSegmentEntry> entries = [];

    int colorIndex = 0;
    for (PollOption option in options) {
      entries.add(new CircularSegmentEntry(
          option.openVotes.toDouble() + option.secretVotes.toDouble(), kGetOptionColor(colorIndex)));
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

  int getTotalVotes(List<PollOption> options) {
    int sum = 0;
    for (PollOption option in options) {
      sum += option.openVotes + option.secretVotes;
    }
    return sum;
  }

  getPollData() async {
    List<String> urls = [];
    urls.add('https://my.api.mockaroo.com/polls.json?key=17d9cc40');
    urls.add('https://my.api.mockaroo.com/polls.json?key=3b82acd0');
    urls.add('https://my.api.mockaroo.com/polls.json?key=873a3a70');

    http.Response response;
    for (var url in urls) {
      response = await http.get(url);
      if (response.statusCode == 200) {
        break;
      }
    }

    try {
      if (response.statusCode == 200) {
        String pollDataCollection = response.body;
        var decodedData = jsonDecode(pollDataCollection);
        for (var pollData in decodedData) {
          PollData poll = pollDataFromJson(pollData);

          if (this.mounted == true) {
            setState(() {
              _pollList.add(poll);
            });
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
            height: 4.0,
            color: Colors.grey,
          ),
      itemCount: _pollList.length,
      itemBuilder: (context, index) {
        return ListTile(
          contentPadding: EdgeInsets.only(left: 10.0),
          title: Text(
            '${_pollList[index].title}',
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            '${_pollList[index].createdBy} - ${getTotalVotes(_pollList[index].options)} Votes',
          ),
          trailing: _pollList[index].voted == true
              ? AnimatedCircularChart(
                  size: const Size(80.0, 80.0),
                  initialChartData: getChartData(_pollList[index].options),
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
            _pollList[index].voted == true
                ? Navigator.pushNamed(
                    context,
                    PollResultScreen.id,
                    arguments: _pollList[index]
                  )
                : Navigator.pushNamed(
                    context,
                    PollVoteScreen.id,
                    arguments: _pollList[index]
                  );
          },
        );
      },
    );
  }
}
