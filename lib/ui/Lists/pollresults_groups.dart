import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:loudly/Models/grouppollresult.dart';
import 'package:loudly/Models/polldata.dart';
import 'package:loudly/ui/widgets/consolidatedvotechart.dart';
import 'package:loudly/ui/widgets/voteshare.dart';

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
          ConsolidatedVoteChart(
            pollResultOptions: pollResult.options,
          ),
          VoteShare(
            pollResultOptions: pollResult.options,
          ),
        ],
      ),
    ]);
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