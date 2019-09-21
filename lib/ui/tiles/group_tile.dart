import 'package:flutter/material.dart';
import 'package:loudly/project_enums.dart';
import 'package:loudly/providers/group.dart';
import 'package:loudly/ui/widgets/styledtext.dart';
import 'package:provider/provider.dart';

class GroupTile extends StatelessWidget {
  final ListAction actionRequired;
  final bool isSelected;
  final String searchText;
  final Function onTap;

  GroupTile({
    @required this.actionRequired,
    @required this.isSelected,
    @required this.searchText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final group = Provider.of<Group>(context);

    return ListTile(
      title: StyledText(group.title, searchText),
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
