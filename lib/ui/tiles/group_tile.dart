import 'package:flutter/material.dart';
import 'package:loudly/project_enums.dart';
import 'package:loudly/providers/group.dart';
import 'package:provider/provider.dart';

class GroupTile extends StatelessWidget {
  final ListAction actionRequired;
  final bool isSelected;
  final Function onTap;

  GroupTile({
    @required this.actionRequired,
    @required this.isSelected,
    this.onTap,
  });

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
      trailing: actionRequired == ListAction.Select
          ? Checkbox(
              value: isSelected,
              onChanged: (value) {},
            )
          : Container(
              width: 0,
              height: 0,
            ),
      //leading: Image.network(_groupList[index].image),
      onTap: () {
        if (onTap != null) onTap();
      },
    );
  }
}
