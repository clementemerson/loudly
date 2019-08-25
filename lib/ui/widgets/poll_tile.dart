import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:loudly/project_styles.dart';
import 'package:loudly/providers/poll.dart';
import 'package:loudly/providers/poll_option.dart';
import 'package:loudly/ui/Screens/pollresult_screen.dart';
import 'package:loudly/ui/Screens/pollvote_screen.dart';
import 'package:loudly/utilities.dart';
import 'package:provider/provider.dart';

class PollTile extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    final poll = Provider.of<Poll>(context);
    return ListTile(
      contentPadding: EdgeInsets.only(left: 10.0),
      title: Text(
        '${poll.title}',
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${poll.createdBy} - ${getTotalVotes(poll.options)} Votes',
      ),
      trailing: poll.voted == true
          ? AnimatedCircularChart(
              size: const Size(80.0, 80.0),
              initialChartData: _getChartData(poll.options),
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
        poll.voted == true
            ? Navigator.pushNamed(context, PollResultScreen.id,
                arguments: poll.pollid)
            : Navigator.pushNamed(context, PollVoteScreen.id,
                arguments: poll.pollid);
      },
    );
  }
}
