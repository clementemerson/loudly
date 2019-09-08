import 'package:flutter/material.dart';
import 'package:loudly/common_widgets.dart';
import 'package:loudly/project_enums.dart';
import 'package:loudly/providers/group.dart';
import 'package:loudly/providers/poll.dart';
import 'package:loudly/providers/poll_store.dart';
import 'package:loudly/resources/ws/event_handlers/pollmodule.dart';
import 'package:loudly/ui/Lists/group_list.dart';
import 'package:provider/provider.dart';

class ShareContentScreen extends StatefulWidget {
  static final String route = 'sharecontent_screen';

  @override
  _ShareContentScreenState createState() => _ShareContentScreenState();
}

class _ShareContentScreenState extends State<ShareContentScreen> {
  String searchText = '';
  List<Group> selectedGroup = [];

  @override
  Widget build(BuildContext context) {
    final int pollid = ModalRoute.of(context).settings.arguments as int;
    final Poll poll = Provider.of<PollStore>(context).findById(pollid: pollid);

    return Scaffold(
      appBar: buildAppBar(poll, context),
      body: Column(
        children: <Widget>[
          kUserInputTextField(
              helperText: 'Search',
              maxLen: null,
              fontSize: 16.0,
              keyboardType: TextInputType.text,
              onChanged: (text) {
                setState(() {
                  if (this.mounted == true) {
                    searchText = text;
                  }
                });
              }),
          Expanded(
            child: GroupList(
                actionRequired: ListAction.Select,
                selectedGroups: selectedGroup,
                searchText: this.searchText),
          )
        ],
      ),
    );
  }

  AppBar buildAppBar(Poll poll, BuildContext context) {
    return AppBar(
      title: Text('Share Poll'),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.done,
          ),
          onPressed: () {
            if (selectedGroup.isNotEmpty) {
              List<int> groupids = List<int>.from(
                  this.selectedGroup.map((group) => group.groupid));
              WSPollsModule.shareToGroup(poll.pollid, groupids, callback: () {
                Navigator.pop(context);
              });
            }
          },
        ),
      ],
    );
  }
}
