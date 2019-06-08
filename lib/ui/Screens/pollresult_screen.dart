import 'package:flutter/material.dart';

import 'package:flutter_circular_chart/flutter_circular_chart.dart';

import 'package:loudly/Models/polldata.dart';
import 'package:loudly/common_widgets.dart';
import 'package:loudly/project_settings.dart';
import 'package:loudly/project_styles.dart';

class PollResultScreen extends StatefulWidget {
  static const String id = 'pollresult_screen';

  @override
  _PollResultScreenState createState() => _PollResultScreenState();
}

class _PollResultScreenState extends State<PollResultScreen> {
  PollData pollData;

  AppBar _getAppBar() {
    return AppBar(
      title: Text('Poll Result'),
    );
  }

  Widget _getVoteTitleTextField() {
    return Container(
      padding: EdgeInsets.only(
        left: 12.0,
        right: 12.0,
      ),
      child: Text(
        pollData.title,
        textAlign: TextAlign.justify,
        style: TextStyle(
          color: Colors.blueAccent,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  getConsolidatedChartData(List<Option> options) {
    List<CircularSegmentEntry> entries = [];

    int colorIndex = 0;
    for (Option option in options) {
      entries.add(new CircularSegmentEntry(
          option.openVotes.toDouble() + option.secretVotes.toDouble(),
          kGetOptionColor(colorIndex)));
      colorIndex++;
    }

    return <CircularStackEntry>[
      new CircularStackEntry(entries),
    ];
  }

  int getTotalVotes(List<Option> options) {
    int sum = 0;
    for (Option option in options) {
      sum += option.openVotes + option.secretVotes;
    }
    return sum;
  }

  getOpenVotesChartData(List<Option> options) {
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

  int getTotalOpenVotes(List<Option> options) {
    int sum = 0;
    for (Option option in options) {
      sum += option.openVotes;
    }
    return sum;
  }

  getSecretVotesChartData(List<Option> options) {
    List<CircularSegmentEntry> entries = [];

    int colorIndex = 0;
    for (Option option in options) {
      entries.add(new CircularSegmentEntry(
          option.secretVotes.toDouble(), kGetOptionColor(colorIndex)));
      colorIndex++;
    }

    return <CircularStackEntry>[
      new CircularStackEntry(entries),
    ];
  }

  int getTotalSecretVotes(List<Option> options) {
    int sum = 0;
    for (Option option in options) {
      sum += option.secretVotes;
    }
    return sum;
  }

  List<Widget> _getTotalVoteShare() {
    final List<Widget> widgets = [];
    int index = 0;
    for (Option option in pollData.options) {
      widgets.add(_getTotalVoteShareForOption(option: option, index: index));
      index++;
    }
    return widgets;
  }

  Widget _getTotalVoteShareForOption({Option option, int index}) {
    return Row(
      children: <Widget>[
        kGetColorBox(index: index),
        Text((option.secretVotes + option.openVotes).toString()),
      ],
    );
  }

  List<Widget> _getCategorizedVoteShare() {
    final List<Widget> widgets = [];
    int index = 0;
    for (Option option in pollData.options) {
      widgets.add(_getVoteShareForOption(option: option, index: index));
      index++;
    }
    return widgets;
  }

  Widget _getVoteShareForOption({Option option, int index}) {
    return Row(
      children: <Widget>[
        Text(option.openVotes.toString()),
        kGetColorBox(index: index),
        Text(option.secretVotes.toString()),
      ],
    );
  }

  List<Widget> _getAllOptions() {
    final List<Widget> widgets = [];
    int index = 0;
    for (Option option in pollData.options) {
      widgets.add(_getOptionsField(optionText: option.desc, index: index));
      index++;
    }
    return widgets;
  }

  Widget _getOptionsField({String optionText, int index}) {
    return Row(
      children: <Widget>[
        kGetColorBox(index: index),
        Text(
          optionText,
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    pollData = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: _getAppBar(),
      body: Container(
        padding: const EdgeInsets.all(
          12.0,
        ),
        child: ListView(
          children: [
            Row(
              children: <Widget>[
                Icon(
                  kProjectIcon,
                  size: kIcon_Small,
                  color: Colors.blue,
                ),
                Expanded(
                  child: _getVoteTitleTextField(),
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Center(
              child: Text('Consolidated - ' +
                  getTotalVotes(pollData.options).toString()),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AnimatedCircularChart(
                  size: const Size(200.0, 200.0),
                  initialChartData: getConsolidatedChartData(pollData.options),
                  chartType: CircularChartType.Pie,
                  duration: Duration(
                    seconds: 1,
                  ),
                ),
                Column(
                  children: _getTotalVoteShare(),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: Text(
                          'Open Votes - ' +
                              getTotalOpenVotes(pollData.options).toString(),
                        ),
                      ),
                      AnimatedCircularChart(
                        size: const Size(120.0, 120.0),
                        initialChartData:
                            getOpenVotesChartData(pollData.options),
                        chartType: CircularChartType.Pie,
                        duration: Duration(
                          seconds: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: _getCategorizedVoteShare(),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: Text(
                          'Secret Votes - ' +
                              getTotalSecretVotes(pollData.options).toString(),
                        ),
                      ),
                      AnimatedCircularChart(
                        size: const Size(120.0, 120.0),
                        initialChartData:
                            getSecretVotesChartData(pollData.options),
                        chartType: CircularChartType.Pie,
                        duration: Duration(
                          seconds: 1,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Column(
              children: _getAllOptions(),
            ),
          ],
        ),
      ),
    );
  }
}
