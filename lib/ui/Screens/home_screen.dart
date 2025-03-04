import 'dart:core';

import 'package:flutter/material.dart';
import 'package:loudly/ui/Lists/group_list.dart';
import 'package:loudly/ui/Lists/poll_list.dart';

import 'package:loudly/common_widgets.dart';
import 'package:loudly/project_enums.dart';
import 'package:loudly/project_settings.dart';

class HomeScreen extends StatefulWidget {
  static final String route = 'home_screen';
  static final String homeTabTitle = 'HOME';
  static final String groupsTabTitle = 'GROUPS';
  static final String myPollsTabTitle = 'MY POLLS';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(text: HomeScreen.homeTabTitle),
              Tab(text: HomeScreen.groupsTabTitle),
              Tab(text: HomeScreen.myPollsTabTitle),
            ],
          ),
          title: Text(projectName),
          actions: <Widget>[
            kSearchWidget(context),
            kMainScreenPopupMenu(context),
          ],
        ),
        body: TabBarView(
          children: [
            PollList(
              pollListType: PollListType.All,
            ),
            GroupList(
              actionRequired: ListAction.None,
              selectedGroups: null,
            ),
            PollList(
              pollListType: PollListType.User,
            ),
          ],
        ),
      ),
    );
  }
}
