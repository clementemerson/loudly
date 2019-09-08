import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:loudly/common_widgets.dart';
import 'package:loudly/providers/user.dart';
import 'package:loudly/resources/ws/event_handlers/groupmodule.dart';
import 'package:loudly/ui/Screens/groupparticipants_screen.dart';
import 'package:loudly/ui/widgets/avatarlist.dart';

class NewGroupScreen extends StatefulWidget {
  static final String route = 'newgroup_screen';
  static final String appBarTitle = 'New Group';
  static final String createGroup = 'Create Group';
  static final String groupName = 'Group Name';
  static final String groupStatus = 'Status Message';

  @override
  _NewGroupScreenState createState() => _NewGroupScreenState();
}

class _NewGroupScreenState extends State<NewGroupScreen> {
  List<User> _selectedUsers = List<User>();
  String groupName = '';
  String groupDesc = '';

  AppBar _getAppBar() {
    return AppBar(
      title: Text(NewGroupScreen.appBarTitle),
    );
  }

  Widget _getCreateGroupButton({Function onPressed}) {
    return RaisedButton(
      padding: EdgeInsets.all(10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      textColor: Colors.white,
      disabledTextColor: Colors.grey,
      onPressed: onPressed,
      child: Text(
        NewGroupScreen.createGroup,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getAppBar(),
      body: Container(
        padding: EdgeInsets.all(12.0),
        child: ListView(
          children: <Widget>[
            kUserInputTextField(
                helperText: NewGroupScreen.groupName,
                maxLen: 25,
                fontSize: 24.0,
                keyboardType: TextInputType.text,
                onChanged: (text) {
                  setState(() {
                    groupName = text;
                  });
                }),
            kUserInputTextField(
                helperText: NewGroupScreen.groupStatus,
                maxLen: 50,
                fontSize: 12.0,
                keyboardType: TextInputType.text,
                onChanged: (text) {
                  setState(() {
                    groupDesc = text;
                  });
                }),
            SizedBox(
              height: 20.0,
            ),
            IconButton(
              icon: Icon(Icons.group),
              onPressed: () {
                Navigator.pushNamed(context, GroupParticipantsScreen.route,
                    arguments: [..._selectedUsers]).then((onValue) {
                  setState(() {
                    _selectedUsers.clear();
                    _selectedUsers.addAll(onValue);
                  });
                });
              },
            ),
            _selectedUsers.isNotEmpty
                ? Container(
                    child: AvatarList(
                      texts: List<String>.from(
                          _selectedUsers.map((user) => user.displayName)),
                    ),
                  )
                : Container(
                    height: 0.0,
                    width: 0.0,
                  ),
            _getCreateGroupButton(
                onPressed: (_selectedUsers.isNotEmpty &&
                        groupName.isNotEmpty &&
                        groupDesc.isNotEmpty)
                    ? () {
                        Set<int> userids = Set<int>.from(
                            this._selectedUsers.map((user) => user.userid));
                        WSGroupsModule.create(
                            groupName.trim(), groupDesc.trim(), userids,
                            callback: () {
                          Navigator.pop(context);
                        });
                      }
                    : null),
          ],
        ),
      ),
    );
  }
}
