import 'package:flutter/material.dart';

import 'package:loudly/providers/poll.dart';
import 'package:loudly/ui/widgets/grouppollresult.dart';
import 'package:provider/provider.dart';

class GroupPollResults extends StatelessWidget {
  static final String resultsFromGroup = 'Poll results from your groups';

  @override
  Widget build(BuildContext context) {
    final Poll poll = Provider.of<Poll>(context);
    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      children: [
      Center(
        child: Text(
          GroupPollResults.resultsFromGroup,
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
      ),
      SizedBox(
        height: 10.0,
      ),
      ListView.separated(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        separatorBuilder: (context, index) => Divider(
          height: 4.0,
          color: Colors.grey,
        ),
        itemCount: poll.groupPollCatalog.pollInfos.length,
        itemBuilder: (context, index) => ChangeNotifierProvider.value(
          value: poll.groupPollCatalog.pollInfos[index],
          child: GroupPollResult(),
        ),
      )
    ]);
  }
}
