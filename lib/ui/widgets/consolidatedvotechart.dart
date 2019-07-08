import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';

import 'package:loudly/Models/polldata.dart';
import 'package:loudly/project_styles.dart';

class ConsolidatedVoteChart extends StatefulWidget {
  const ConsolidatedVoteChart({
    Key key,
    @required this.pollResultOptions,
  }) : super(key: key);

  final List<PollOption> pollResultOptions;

  @override
  _ConsolidatedVoteChartState createState() => _ConsolidatedVoteChartState();
}

class _ConsolidatedVoteChartState extends State<ConsolidatedVoteChart> {
  getConsolidatedChartData(List<PollOption> options) {
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

  @override
  Widget build(BuildContext context) {
    return AnimatedCircularChart(
      size: const Size(200.0, 200.0),
      initialChartData: getConsolidatedChartData(widget.pollResultOptions),
      chartType: CircularChartType.Pie,
      //percentageValues: true,
      duration: Duration(
        seconds: 1,
      ),
    );
  }
}