import 'dart:core';

import 'package:flutter/material.dart';

import 'package:loudly/providers/grouplist.dart';
import 'package:loudly/ui/widgets/group_tile.dart';
import 'package:provider/provider.dart';

class GroupList extends StatelessWidget {
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
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        value: groupList[index],
        child: GroupTile(),
      ),
    );
  }
}
