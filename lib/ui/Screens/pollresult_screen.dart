import 'package:flutter/material.dart';

import 'package:flutter_circular_chart/flutter_circular_chart.dart';

import 'package:loudly/Models/polldata.dart';
import 'package:loudly/common_widgets.dart';
import 'package:loudly/project_settings.dart';
import 'package:loudly/project_styles.dart';
import 'package:loudly/ui/Lists/pollresults_groups.dart';

class PollResultScreen extends StatefulWidget {
  static const String id = 'pollresult_screen';

  @override
  _PollResultScreenState createState() => _PollResultScreenState();
}

class _PollResultScreenState extends State<PollResultScreen> {
  PollData pollData;

  AppBar _getAppBar() {
    return AppBar(title: Text('Poll Result'), actions: <Widget>[
      IconButton(
        icon: Icon(
          Icons.reply,
          textDirection: TextDirection.rtl,
        ),
        onPressed: () {},
      )
    ]);
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
          fontSize: 16.0,
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
      final bool isMax = _isMaxInAllOptions(option);
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
          (option.secretVotes + option.openVotes).toString(),
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

  bool _isMaxInAllOptions(Option option) {
    for (Option itrOption in pollData.options) {
      if ((option.openVotes + option.secretVotes) <
          (itrOption.openVotes + itrOption.secretVotes)) return false;
    }
    return true;
  }

  bool _isMaxInOpenVotes(Option option) {
    for (Option itrOption in pollData.options) {
      if ((option.openVotes) < (itrOption.openVotes)) return false;
    }
    return true;
  }

  bool _isMaxInSecretVotes(Option option) {
    for (Option itrOption in pollData.options) {
      if ((option.secretVotes) < (itrOption.secretVotes)) return false;
    }
    return true;
  }

  List<Widget> _getOpenVotesWidgets() {
    final List<Widget> widgets = [];
    for (Option option in pollData.options) {
      final bool isMax = _isMaxInOpenVotes(option);
      widgets.add(_getOpenVotesWidgetsForOption(option: option, isMax: isMax));
    }
    return widgets;
  }

  Widget _getOpenVotesWidgetsForOption({Option option, bool isMax}) {
    return Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(5.0),
          child: Text(
            option.openVotes.toString(),
            style: isMax == true
                ? TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                  )
                : TextStyle(),
          ),
        ),
      ],
    );
  }

  List<Widget> _getColorBoxWidgets() {
    final List<Widget> widgets = [];
    int index = 0;
    for (Option option in pollData.options) {
      widgets.add(_getColorBoxWidgetsForOption(index: index));
      index++;
    }
    return widgets;
  }

  Widget _getColorBoxWidgetsForOption({int index}) {
    return Row(
      children: <Widget>[
        _getColorBox2(index: index),
      ],
    );
  }

  List<Widget> _getSecretVotesWidgets() {
    final List<Widget> widgets = [];
    for (Option option in pollData.options) {
      final bool isMax = _isMaxInSecretVotes(option);
      widgets
          .add(_getSecretVotesWidgetsForOption(option: option, isMax: isMax));
    }
    return widgets;
  }

  Widget _getSecretVotesWidgetsForOption({Option option, bool isMax}) {
    return Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(5.0),
          child: Text(
            option.secretVotes.toString(),
            style: isMax == true
                ? TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                  )
                : TextStyle(),
          ),
        ),
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
        _getColorBox(index: index),
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

  Widget _getColorBox2({int index}) {
    return Container(
      margin: EdgeInsets.all(3.0),
      padding: EdgeInsets.all(9.0),
      decoration: BoxDecoration(
        color: kGetOptionColor(index),
        border: Border.all(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(6.0),
      ),
    );
  }

  Widget _getPollResultsFromGroups() {
    return GroupPollResults(pollId: pollData.id);
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
              height: 10.0,
            ),
            Divider(
              color: Colors.blueAccent,
            ),
            Center(
              child: Text(
                'Consolidated - ' + getTotalVotes(pollData.options).toString(),
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AnimatedCircularChart(
                  size: const Size(200.0, 200.0),
                  initialChartData: getConsolidatedChartData(pollData.options),
                  chartType: CircularChartType.Pie,
                  //percentageValues: true,
                  duration: Duration(
                    seconds: 1,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _getTotalVoteShare(),
                )
              ],
            ),
            Divider(
              color: Colors.blueAccent,
            ),
            Center(
              child: Text(
                'Vote Share',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 10.0,
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
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: _getOpenVotesWidgets(),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: _getColorBoxWidgets(),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _getSecretVotesWidgets(),
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
                'Poll results from your groups',
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
