import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:loudly/Models/grouppollresult.dart';
import 'package:loudly/project_styles.dart';

class GroupPollResults extends StatefulWidget {
  final int pollId;

  GroupPollResults({@required this.pollId});

  @override
  _GroupPollResultsState createState() => _GroupPollResultsState();
}

class _GroupPollResultsState extends State<GroupPollResults> {
  List<GroupPollResult> _pollResultList = [];

  @override
  void initState() {
    getPollData();
    super.initState();
  }

  getPollData() async {
    List<String> urls = [];
    urls.add('https://my.api.mockaroo.com/grouppollresults.json?key=17d9cc40');
    urls.add('https://my.api.mockaroo.com/polls.json?key=3b82acd0');
    urls.add('https://my.api.mockaroo.com/polls.json?key=873a3a70');

    http.Response response;
    for (var url in urls) {
      response = await http.get(url);
      if (response.statusCode == 200) {
        break;
      } else {
        print(url);
      }
    }

    try {
      if (response.statusCode == 200) {
        String pollDataCollection = response.body;
        var decodedData = jsonDecode(pollDataCollection);
        for (var pollData in decodedData) {
          GroupPollResult pollResult = groupPollResultFromJson(pollData);

          if (this.mounted == true) {
            setState(() {
              _pollResultList.add(pollResult);
            });
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  int getTotalVotes(List<Option> options) {
    int sum = 0;
    for (Option option in options) {
      sum += option.openVotes;
    }
    return sum;
  }

  getConsolidatedChartData(List<Option> options) {
    List<CircularSegmentEntry> entries = [];

    int colorIndex = 0;
    for (Option option in options) {
      entries.add(new CircularSegmentEntry(
          option.openVotes.toDouble(), kGetOptionColor(colorIndex)));
      colorIndex++;
    }

    return <CircularStackEntry>[
      new CircularStackEntry(entries),
    ];
  }

  Widget _getPollResultGroup(GroupPollResult pollResult) {
    return Column(children: <Widget>[
      Center(
        child: Text(
          pollResult.groupName +
              ' - ' +
              getTotalVotes(pollResult.options).toString(),
          style: TextStyle(fontSize: 16.0),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AnimatedCircularChart(
            size: const Size(200.0, 200.0),
            initialChartData: getConsolidatedChartData(pollResult.options),
            chartType: CircularChartType.Pie,
            //percentageValues: true,
            duration: Duration(
              seconds: 1,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _getTotalVoteShare(pollResult),
          )
        ],
      ),
    ]);
  }

  List<Widget> _getTotalVoteShare(GroupPollResult pollResult) {
    final List<Widget> widgets = [];
    int index = 0;
    for (Option option in pollResult.options) {
      final bool isMax = _isMaxInAllOptions(pollResult, option);
      widgets.add(_getTotalVoteShareForOption(
          option: option, index: index, isMax: isMax));
      index++;
    }
    return widgets;
  }

  Widget _getTotalVoteShareForOption({Option option, int index, bool isMax}) {
    return Row(
      children: <Widget>[
        _getColorBox(index: index),
        Text(
          option.openVotes.toString(),
          style: isMax == true
              ? TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                )
              : TextStyle(),
        ),
        SizedBox(
          width: 8.0,
        ),
        isMax == true
            ? Icon(
                Icons.thumb_up,
                color: Colors.yellow,
                size: 20.0,
              )
            : Container(
                height: 0.0,
                width: 0.0,
              ),
      ],
    );
  }

  bool _isMaxInAllOptions(GroupPollResult pollResult, Option option) {
    for (Option itrOption in pollResult.options) {
      if (option.openVotes < itrOption.openVotes) return false;
    }
    return true;
  }

  Widget _getColorBox({int index}) {
    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: kGetOptionColor(index),
        border: Border.all(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }

  List<Widget> _getResultsOfAllGroups() {
    final List<Widget> widgets = [];
    for (GroupPollResult pollResult in _pollResultList) {
      widgets.add(_getPollResultGroup(pollResult));
      widgets.add(
        Divider(),
      );
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _getResultsOfAllGroups(),
    );
  }
}
