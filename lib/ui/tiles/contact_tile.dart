import 'package:flutter/material.dart';
import 'package:loudly/project_enums.dart';
import 'package:loudly/providers/user.dart';
import 'package:loudly/resources/phone_services/contacts_helper.dart';
import 'package:provider/provider.dart';

class ContactTile extends StatelessWidget {
  final ListAction actionRequired;
  final bool isSelected;
  final Function onTap;

  ContactTile({
    @required this.actionRequired,
    @required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    String userName = ContactsHelper.getUserNameInPhone(user.phoneNumber);
    if (userName == null) userName = user.displayName;

    return ListTile(
      title: Text(
        '${userName}',
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${user.statusMsg}',
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
      onTap: actionRequired == ListAction.Select
          ? () {
              if (onTap != null) onTap();
            }
          : null,
    );
  }
}
