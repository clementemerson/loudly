import 'dart:core';

import 'package:flutter/material.dart';

import 'package:loudly/common_widgets.dart';

import 'package:loudly/project_enums.dart';
import 'package:loudly/providers/user.dart';
import 'package:loudly/providers/user_store.dart';
import 'package:provider/provider.dart';

class ContactList extends StatefulWidget {
  final ContactListType contactListType;
  final String groupId;
  final ContactListAction actionRequired;
  final List<User> selectedUsers;

  ContactList(
      {@required this.contactListType,
      this.groupId,
      this.actionRequired,
      this.selectedUsers});

  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  @override
  void initState() {
    super.initState();
  }

  void _addRemoveSelectedList(User contact, bool add) {
    if (add == true) {
      widget.selectedUsers.add(contact);
    } else {
      widget.selectedUsers.remove(contact);
    }
  }

  Widget _getParticipantsList() {
    final userStore = Provider.of<UserStore>(context);
    final userList = userStore.users;

    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
        height: 4.0,
        color: Colors.grey,
      ),
      itemCount: userList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            '${userList[index].displayName}',
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            '${userList[index].statusMsg}',
            overflow: TextOverflow.ellipsis,
          ),
          trailing: widget.actionRequired == ContactListAction.Select
              ? Checkbox(
                  value: _isSelected(userList[index]),
                  onChanged: (value) {
                    if (this.mounted) {
                      setState(() {
                        _addRemoveSelectedList(userList[index], value);
                      });
                    }
                  },
                )
              : Container(
                  width: 0,
                  height: 0,
                ),
          onTap: widget.actionRequired == ContactListAction.Select
              ? () {
                  if (this.mounted) {
                    setState(() {
                      _addRemoveSelectedList(
                          userList[index], !_isSelected(userList[index]));
                    });
                  }
                }
              : null,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        kUserInputTextField(
          helperText: 'Search',
          maxLen: null,
          fontSize: 16.0,
          keyboardType: TextInputType.text,
        ),
        widget.selectedUsers.isNotEmpty
            ? Container(
                height: 80.0,
                child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (context, index) => Divider(
                          height: 4.0,
                          color: Colors.grey,
                        ),
                    itemCount: widget.selectedUsers.length,
                    itemBuilder: (context, index) {
                      return Text(
                        '+',
                        style: TextStyle(fontSize: 12.0),
                      );
                    }),
              )
            : Container(
                height: 0.0,
                width: 0.0,
              ),
        Divider(
          color: Colors.blueAccent,
        ),
        Expanded(
          child: _getParticipantsList(),
        ),
      ],
    );
  }

  _isSelected(User contact) {
    return widget.selectedUsers.indexOf(contact) > -1 ? true : false;
  }
}
