import 'package:flutter/material.dart';
import 'package:loudly/models/groupinfo.dart';
import 'package:loudly/ui/Lists/poll_list.dart';
import 'package:loudly/common_widgets.dart';
import 'package:loudly/project_enums.dart';

class GroupPollListScreen extends StatelessWidget {
  static const String id = 'grouppolllist_screen';

  @override
  Widget build(BuildContext context) {
    final GroupInfo groupInfo = ModalRoute.of(context).settings.arguments;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(groupInfo.name),
          actions: <Widget>[
            kSearchWidget(context),
            kMainScreenPopupMenu(context),
          ],
        ),
        body: PollList(
          pollListType: PollListType.Group,
          groupId: groupInfo.groupid,
        ),
      ),
    );
  }
}
