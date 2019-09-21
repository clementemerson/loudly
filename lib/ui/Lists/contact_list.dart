import 'dart:core';

import 'package:flutter/material.dart';

import 'package:loudly/common_widgets.dart';

import 'package:loudly/project_enums.dart';
import 'package:loudly/providers/user.dart';
import 'package:loudly/providers/user_store.dart';
import 'package:loudly/ui/tiles/contact_tile.dart';
import 'package:loudly/ui/widgets/avatarlist.dart';
import 'package:provider/provider.dart';

class ContactList extends StatefulWidget {
  final ContactListType contactListType;
  final String groupId;
  final ListAction actionRequired;
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
  String searchText = '';

  Widget _getParticipantsList(String searchText) {
    final userStore = Provider.of<UserStore>(context);
    final List<User> userList = _getUserList(userStore);

    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
        height: 4.0,
        color: Colors.grey,
      ),
      itemCount: userList.length,
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        value: userList[index],
        child: ContactTile(
          actionRequired: widget.actionRequired,
          isSelected: _isSelected(userList[index]),
          searchText: searchText,
          onTap: () {
            setState(() {
              if (this.mounted == true) {
                if (widget.selectedUsers.contains(userList[index])) {
                  widget.selectedUsers.remove(userList[index]);
                } else {
                  widget.selectedUsers.add(userList[index]);
                }
              }
            });
          },
        ),
      ),
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
            onChanged: (text) {
              setState(() {
                if (this.mounted == true) {
                  searchText = text;
                }
              });
            }),
        widget.selectedUsers.isNotEmpty
            ? AvatarList(
                texts: List<String>.from(
                    widget.selectedUsers.map((user) => user.displayName)),
              )
            : Container(
                height: 0.0,
                width: 0.0,
              ),
        Divider(
          color: Colors.blueAccent,
        ),
        Expanded(
          child: _getParticipantsList(searchText),
        ),
      ],
    );
  }

  _isSelected(User contact) {
    return widget.selectedUsers.indexOf(contact) > -1 ? true : false;
  }

  _getUserList(UserStore userStore) {
    if (searchText.length > 0)
      return userStore.searchByText(searchText);
    else
      return userStore.users;
  }
}
