import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_circular_chart/flutter_circular_chart.dart';

import 'package:loudly/project_enums.dart';
import 'package:loudly/project_styles.dart';

class PollList extends StatefulWidget {
  final PollListType _pollListType;
  final String groupId;

  PollList(this._pollListType, {this.groupId});

  @override
  _PollListState createState() => _PollListState();
}

class _PollListState extends State<PollList> {
  List<Poll> _pollList = [];

  @override
  void initState() {
    getPollData();

    super.initState();
  }

  getChartData(List<int> votesInAllCategories) {
    List<CircularSegmentEntry> entries = [];

    int colorIndex = 0;
    for (int votesInEachCategory in votesInAllCategories) {
      entries.add(new CircularSegmentEntry(
          votesInEachCategory.toDouble(), kGetColor(colorIndex)));
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

  int getTotalVotes(List<int> votes) {
    int sum = 0;
    for (var receivedVotes in votes) {
      sum += receivedVotes;
    }
    return sum;
  }

  getPollData() async {
    try {
      http.Response response =
          await http.get('https://my.api.mockaroo.com/polls.json?key=17d9cc40');
      if (response.statusCode == 200) {
        String pollDataCollection = response.body;
        var decodedData = jsonDecode(pollDataCollection);
        for (var pollData in decodedData) {
          Poll poll = new Poll(
              id: pollData['id'],
              title: pollData['title'],
              isSecret: pollData['issecret'],
              canBeShared: pollData['canbeshared'],
              createdBy: pollData['createdby'],
              votes: getVoteList(pollData['votes']),
              image: pollData['image']);

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
          contentPadding: EdgeInsets.all(0.0),
          title: Text(
            '${_pollList[index].title}',
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            '${_pollList[index].createdBy} - ${getTotalVotes(_pollList[index].votes)} Votes',
          ),
          leading: Image.network(_pollList[index].image),
          trailing: AnimatedCircularChart(
            size: const Size(80.0, 80.0),
            initialChartData: getChartData(_pollList[index].votes),
            chartType: CircularChartType.Pie,
            duration: Duration(
              seconds: 1,
            ),
          ),
        );
      },
    );
  }
}

class Poll {
  String id;
  String title;
  bool isSecret;
  bool canBeShared;
  String createdBy;
  int createdAt;
  int updatedAt;
  List<int> votes;
  String image;

  Poll(
      {this.id,
      this.title,
      this.isSecret,
      this.canBeShared,
      this.createdBy,
      this.createdAt,
      this.updatedAt,
      this.votes,
      this.image});
}
