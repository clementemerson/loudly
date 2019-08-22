import 'dart:core';

import 'package:flutter/material.dart';

import 'package:loudly/providers/grouplist.dart';
import 'package:loudly/ui/Screens/grouppolllist_screen.dart';
import 'package:provider/provider.dart';

class GroupList extends StatefulWidget {
  @override
  _GroupListState createState() => _GroupListState();
}

class _GroupListState extends State<GroupList> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final groupStore = Provider.of<GroupStore>(context);
    final groupList = groupStore.groups;

    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
        height: 4.0,
        color: Colors.grey,
      ),
      itemCount: groupList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            '${groupList[index].title}',
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            '${groupList[index].desc}',
            overflow: TextOverflow.ellipsis,
          ),
          //leading: Image.network(_groupList[index].image),
          onTap: () {
            Navigator.pushNamed(context, GroupPollListScreen.id,
                arguments: groupList[index]);
          },
        );
      },
    );
  }
}
