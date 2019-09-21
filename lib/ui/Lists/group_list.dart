import 'dart:core';

import 'package:flutter/material.dart';
import 'package:loudly/project_enums.dart';
import 'package:loudly/providers/group.dart';
import 'package:loudly/providers/group_store.dart';
import 'package:loudly/ui/Screens/grouppolllist_screen.dart';
import 'package:loudly/ui/tiles/group_tile.dart';

import 'package:provider/provider.dart';

class GroupList extends StatefulWidget {
  final ListAction actionRequired;
  final List<Group> selectedGroups;
  final String searchText;

  GroupList({this.actionRequired, this.selectedGroups, this.searchText = ''});

  @override
  _GroupListState createState() => _GroupListState();
}

class _GroupListState extends State<GroupList> {
  _isSelected(Group group) {
    if (widget.selectedGroups == null) return false;
    return widget.selectedGroups.indexOf(group) > -1 ? true : false;
  }

  Widget _getGroupList() {
    final groupStore = Provider.of<GroupStore>(context);
    final List<Group> groupList = _filterGroups(groupStore);

    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
        height: 4.0,
        color: Colors.grey,
      ),
      itemCount: groupList.length,
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        value: groupList[index],
        child: GroupTile(
          actionRequired: widget.actionRequired,
          isSelected: _isSelected(groupList[index]),
          searchText: widget.searchText,
          onTap: (widget.actionRequired == ListAction.Select)
              ? () {
                  setState(() {
                    if (this.mounted == true) {
                      if (widget.selectedGroups.contains(groupList[index])) {
                        widget.selectedGroups.remove(groupList[index]);
                      } else {
                        widget.selectedGroups.add(groupList[index]);
                      }
                    }
                  });
                }
              : () {
                  Navigator.pushNamed(context, GroupPollListScreen.route,
                      arguments: groupList[index].groupid);
                },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: _getGroupList(),
        ),
      ],
    );
  }

  List<Group> _filterGroups(GroupStore groupStore) {
    if (widget.searchText.length > 0)
      return groupStore.searchByText(widget.searchText);
    else
      return groupStore.groups;
  }
}
