import 'package:flutter/material.dart';

import 'package:loudly/project_settings.dart';
import 'package:loudly/project_styles.dart';
import 'package:loudly/providers/poll.dart';
import 'package:loudly/providers/poll_store.dart';
import 'package:loudly/ui/Lists/pollresults_groups.dart';
import 'package:loudly/ui/widgets/poll_consolidated_result.dart';
import 'package:loudly/ui/widgets/votetitle.dart';
import 'package:provider/provider.dart';

class PollResultScreen extends StatelessWidget {
  static final String route = 'pollresult_screen';
  static final String appBarTitle = 'Poll Result';

  AppBar _getAppBar() {
    return AppBar(title: Text(PollResultScreen.appBarTitle), actions: <Widget>[
      IconButton(
        icon: Icon(
          Icons.reply,
          textDirection: TextDirection.rtl,
        ),
        onPressed: () {},
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final int pollid = ModalRoute.of(context).settings.arguments as int;
    final Poll poll = Provider.of<PollStore>(context).findById(pollid: pollid);

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
                  projectIcon,
                  size: kIcon_Small,
                  color: Colors.blue,
                ),
                Expanded(
                  child: VoteTitle(
                    title: poll.title,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Divider(
              color: Colors.blueAccent,
            ),
            ChangeNotifierProvider.value(
              value: poll,
              child: PollConsolidatedResult(),
            ),
            Divider(
              color: Colors.blueAccent,
            ),
            ChangeNotifierProvider.value(
              value: poll,
              child: GroupPollResults(),
            )
          ],
        ),
      ),
    );
  }
}
