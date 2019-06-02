import 'package:flutter/material.dart';
import 'package:loudly/Lists/poll_list.dart';
import 'package:loudly/common_widgets.dart';
import 'package:loudly/project_enums.dart';

class GroupPollListScreen extends StatelessWidget {
  
  static const String id = 'grouppolllist_screen';
  
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Group Name'),
            actions: <Widget>[
              kSearchWidget(context),
              kMainScreenPopupMenu(context),
            ],
          ),
          body: PollList(PollListType.All),
      ),
    );
  }
}