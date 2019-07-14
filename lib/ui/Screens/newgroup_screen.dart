import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:loudly/common_widgets.dart';
import 'package:loudly/models/userinfo.dart';
import 'package:loudly/resources/ws/event_handlers/groupmodule.dart';
import 'package:loudly/ui/Screens/groupparticipants_screen.dart';

class NewGroupScreen extends StatefulWidget {
  static const String id = 'newgroup_screen';

  @override
  _NewGroupScreenState createState() => _NewGroupScreenState();
}

class _NewGroupScreenState extends State<NewGroupScreen> {
  List<UserInfo> _selectedUsers = List<UserInfo>();
  String groupName = '';
  String groupDesc = '';

  AppBar _getAppBar() {
    return AppBar(
      title: Text('New Group'),
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
        'Create Group',
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
                helperText: 'Group Name',
                maxLen: 25,
                fontSize: 24.0,
                keyboardType: TextInputType.text,
                onChanged: (text) {
                  setState(() {
                    groupName = text;
                  });
                }),
            kUserInputTextField(
                helperText: 'Status Message',
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
                Navigator.pushNamed(context, GroupParticipantsScreen.id,
                        arguments: _selectedUsers)
                    .then((onValue) {
                  setState(() {
                    _selectedUsers.clear();
                    _selectedUsers.addAll(onValue);
                  });
                  print(onValue);
                });
              },
            ),
            _selectedUsers.length > 0
                ? Column(
                    children: [
                      Container(
                        height: 80.0,
                        child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            separatorBuilder: (context, index) => Divider(
                                  height: 4.0,
                                  color: Colors.grey,
                                ),
                            itemCount: _selectedUsers.length,
                            itemBuilder: (context, index) {
                              return Text(
                                '+',
                                style: TextStyle(fontSize: 12.0),
                              );
                            }),
                      ),
                      (groupName.trim().length > 0 &&
                              groupDesc.trim().length > 0)
                          ? Row(
                              children: <Widget>[
                                Expanded(
                                  child: _getCreateGroupButton(onPressed: () {
                                    WSGroupsModule.create(
                                        groupName.trim(), groupDesc.trim(),
                                        callback: () {
                                      Navigator.pop(context);
                                    });
                                  }),
                                ),
                              ],
                            )
                          : Container(
                              height: 0.0,
                              width: 0.0,
                            ),
                    ],
                  )
                : Container(
                    height: 0.0,
                    width: 0.0,
                  ),
          ],
        ),
      ),
    );
  }
}
