import 'package:flutter/material.dart';
import 'package:loudly/models/userinfo.dart';
import 'package:loudly/project_enums.dart';
import 'package:loudly/ui/Lists/contact_list.dart';

class GroupParticipantsScreen extends StatefulWidget {
  static final String id = 'grpparticipants_screen';
  static final String appBarTitle = 'Add or Remove Group Members';

  @override
  _GroupParticipantsScreenState createState() =>
      _GroupParticipantsScreenState();
}

class _GroupParticipantsScreenState extends State<GroupParticipantsScreen> {
  final List<UserInfo> _selectedUsers = List<UserInfo>();
  
  AppBar _getAppBar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.chevron_left),
        onPressed: () => Navigator.pop(context, _selectedUsers),
      ),
      title: Text(GroupParticipantsScreen.appBarTitle),
    );
  }

  Widget _getParticipantsList() {
    return ContactList(
      contactListType: ContactListType.AllLoudly,
      actionRequired: ContactListAction.Select,
      selectedUsers: _selectedUsers,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getAppBar(),
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
