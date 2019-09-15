import 'package:flutter/material.dart';
import 'package:loudly/providers/group_store.dart';
import 'package:loudly/ui/Lists/poll_list.dart';
import 'package:loudly/common_widgets.dart';
import 'package:loudly/project_enums.dart';

class GroupPollListScreen extends StatelessWidget {
  static final String route = 'grouppolllist_screen';

  @override
  Widget build(BuildContext context) {
    final groupid = ModalRoute.of(context).settings.arguments as int;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(GroupStore.store.findById(id: groupid).title),
          actions: <Widget>[
            kSearchWidget(context),
            kMainScreenPopupMenu(context),
          ],
        ),
        body: PollList(
          pollListType: PollListType.Group,
          groupid: groupid,
        ),
      ),
    );
  }
}
