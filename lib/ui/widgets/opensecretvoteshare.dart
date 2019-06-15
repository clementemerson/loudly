import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';

import 'package:loudly/Models/polldata.dart';
import 'package:loudly/project_styles.dart';
import 'package:loudly/ui/widgets/pollresultwidgets.dart';

class OpenSecretVoteShare extends StatefulWidget {
  const OpenSecretVoteShare({
    Key key,
    @required this.pollResultOptions,
  }) : super(key: key);

  final List<Option> pollResultOptions;

  @override
  _OpenSecretVoteShareState createState() => _OpenSecretVoteShareState();
}

class _OpenSecretVoteShareState extends State<OpenSecretVoteShare> {
  int getTotalOpenVotes(List<Option> options) {
    int sum = 0;
    for (Option option in options) {
      sum += option.openVotes;
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

  List<Widget> _getOpenVotesWidgets() {
    final List<Widget> widgets = [];
    for (Option option in widget.pollResultOptions) {
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
    for (Option option in widget.pollResultOptions) {
      widgets.add(_getColorBoxWidgetsForOption(index: index));
      index++;
    }
    return widgets;
  }

  Widget _getColorBoxWidgetsForOption({int index}) {
    return Row(
      children: <Widget>[
        ColorBoxSmall(index: index),
      ],
    );
  }

  List<Widget> _getSecretVotesWidgets() {
    final List<Widget> widgets = [];
    for (Option option in widget.pollResultOptions) {
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

  bool _isMaxInOpenVotes(Option option) {
    for (Option itrOption in widget.pollResultOptions) {
      if ((option.openVotes) < (itrOption.openVotes)) return false;
    }
    return true;
  }

  bool _isMaxInSecretVotes(Option option) {
    for (Option itrOption in widget.pollResultOptions) {
      if ((option.secretVotes) < (itrOption.secretVotes)) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
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
                          getTotalOpenVotes(widget.pollResultOptions)
                              .toString(),
                    ),
                  ),
                  AnimatedCircularChart(
                    size: const Size(120.0, 120.0),
                    initialChartData:
                        getOpenVotesChartData(widget.pollResultOptions),
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
                          getTotalSecretVotes(widget.pollResultOptions)
                              .toString(),
                    ),
                  ),
                  AnimatedCircularChart(
                    size: const Size(120.0, 120.0),
                    initialChartData:
                        getSecretVotesChartData(widget.pollResultOptions),
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
      ],
    );
  }
}
