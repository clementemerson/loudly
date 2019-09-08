import 'package:flutter/material.dart';
import 'package:loudly/project_enums.dart';
import 'package:loudly/providers/user.dart';
import 'package:loudly/ui/Lists/contact_list.dart';

class GroupParticipantsScreen extends StatelessWidget {
  static final String route = 'grpparticipants_screen';
  static final String appBarTitle = 'Add or Remove Group Members';

  final List<User> selectedUsers;

  GroupParticipantsScreen({
    this.selectedUsers,
  });

  AppBar _getAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.chevron_left),
        onPressed: () => Navigator.pop(context, this.selectedUsers),
      ),
      title: Text(GroupParticipantsScreen.appBarTitle),
    );
  }

  Widget _getParticipantsList() {
    return ContactList(
      contactListType: ContactListType.AllLoudly,
      actionRequired: ListAction.Select,
      selectedUsers: this.selectedUsers,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getAppBar(context),
      body: Container(
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: _getParticipantsList(),
            ),
          ],
        ),
      ),
    );
  }
}
