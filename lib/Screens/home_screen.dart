import 'dart:convert';
import 'dart:core';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_circular_chart/flutter_circular_chart.dart';

import 'package:loudly/common_widgets.dart';
import 'package:loudly/project_settings.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Poll> _pollList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPollData();
  }

  Color getColor(int schemeindex, int index) {
    if (schemeindex == 0) {
      switch (index) {
        case 0:
          return Color(0xff63ab70);
          break;
        case 1:
          return Color(0xFFfde987);
          break;
        case 2:
          return Color(0xFFf9b25f);
          break;
        default:
          return Colors.orange;
          break;
      }
    } else if (schemeindex == 1) {
      switch (index) {
        case 0:
          return Color(0xff779075);
          break;
        case 1:
          return Color(0xFFde425b);
          break;
        case 2:
          return Color(0xFFeaa371);
          break;
        default:
          return Colors.orange;
          break;
      }
    } else {
      switch (index) {
        case 0:
          return Color(0xff1d5690);
          break;
        case 1:
          return Color(0xFF3edeaa);
          break;
        case 2:
          return Color(0xFF85e5fb);
          break;
        default:
          return Colors.orange;
          break;
      }
    }
  }

  getChartData(List<int> votesInAllCategories) {
    List<CircularSegmentEntry> entries = [];

    int randomColorScheme = Random().nextInt(3);
    print(randomColorScheme);
    int colorIndex = 0;
    for (int votesInEachCategory in votesInAllCategories) {
      entries.add(new CircularSegmentEntry(votesInEachCategory.toDouble(),
          getColor(randomColorScheme, colorIndex)));
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

          setState(() {
            _pollList.add(poll);
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(kProjectName),
        actions: <Widget>[
          kSearchWidget(context),
          kPopupMenuItem(context),
        ],
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => Divider(
              height: 4.0,
              color: Colors.grey,
            ),
        itemCount: _pollList.length,
        itemBuilder: (context, index) {
          return ListTile(
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
            ),
          );
        },
      ),
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
