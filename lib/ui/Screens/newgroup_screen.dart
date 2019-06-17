import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loudly/project_enums.dart';

import 'package:loudly/common_widgets.dart';
import 'package:loudly/ui/Lists/contact_list.dart';
import 'package:loudly/ui/Screens/groupparticipants_screen.dart';

class NewGroupScreen extends StatelessWidget {
  static const String id = 'newgroup_screen';

  AppBar _getAppBar() {
    return AppBar(
      title: Text('New Group'),
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
            kUserInputTextField(
              helperText: 'Group Name',
              maxLen: 25,
              fontSize: 24.0,
              keyboardType: TextInputType.text,
            ),
            kUserInputTextField(
              helperText: 'Status Message',
              maxLen: 50,
              fontSize: 12.0,
              keyboardType: TextInputType.text,
            ),
            SizedBox(
              height: 20.0,
            ),
            IconButton(
              icon: Icon(Icons.group),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  GroupParticipantsScreen.id,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
