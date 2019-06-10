import 'package:flutter/material.dart';
import 'package:loudly/project_enums.dart';
import 'package:loudly/ui/Lists/contact_list.dart';

class GroupParticipantsScreen extends StatefulWidget {
  static const String id = 'grpparticipants_screen';

  @override
  _GroupParticipantsScreenState createState() =>
      _GroupParticipantsScreenState();
}

class _GroupParticipantsScreenState extends State<GroupParticipantsScreen> {
  AppBar _getAppBar() {
    return AppBar(
      title: Text('Add or Remove Group Members'),
    );
  }

  Widget _getParticipantsList() {
    return ContactList(
      contactListType: ContactListType.AllLoudly,
      actionRequired: ContactListAction.Select,
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
