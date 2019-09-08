import 'package:flutter/material.dart';
import 'package:loudly/providers/group.dart';
import 'package:loudly/ui/Screens/grouppolllist_screen.dart';
import 'package:provider/provider.dart';

class GroupTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final group = Provider.of<Group>(context);

    return ListTile(
      title: Text(
        '${group.title}',
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${group.desc}',
        overflow: TextOverflow.ellipsis,
      ),
      //leading: Image.network(_groupList[index].image),
      onTap: () {
        Navigator.pushNamed(context, GroupPollListScreen.route,
            arguments: group.groupid);
      },
    );
  }
}