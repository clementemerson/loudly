import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:loudly/common_widgets.dart';
import 'package:loudly/models/userinfo.dart';

import 'package:loudly/project_enums.dart';

class ContactList extends StatefulWidget {
  final ContactListType contactListType;
  final String groupId;
  final ContactListAction actionRequired;
  final List<UserInfo> selectedUsers;

  ContactList(
      {@required this.contactListType, this.groupId, this.actionRequired, this.selectedUsers});

  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  List<UserInfo> _contactList = [];
  
  @override
  void initState() {
    _getContactDataFromDB();

    super.initState();
  }

  _getContactDataFromDB() async {
    try {
      List<UserInfo> userList = await UserInfo.getAll();
      setState(() {
        if (this.mounted) _contactList.addAll(userList);
      });
    } catch (e) {
      print(e);
    }
  }

  getContactsData() async {
    List<String> urls = [];
    urls.add('https://my.api.mockaroo.com/contacts.json?key=17d9cc40');
    urls.add('https://my.api.mockaroo.com/contacts.json?key=3b82acd0');
    urls.add('https://my.api.mockaroo.com/contacts.json?key=873a3a70');

    http.Response response;
    for (var url in urls) {
      response = await http.get(url);
      if (response.statusCode == 200) {
        break;
      }
    }

    try {
      if (response.statusCode == 200) {
        String groupDataCollection = response.body;
        var decodedData = jsonDecode(groupDataCollection);
        for (var contactData in decodedData) {
          UserInfo group = UserInfo(
              userId: contactData['id'],
              name: contactData['name'],
              statusMsg: contactData['statusmsg'],
              phoneNumber: 'dfsdfsdf');

          if (this.mounted == true) {
            setState(() {
              _contactList.add(group);
            });
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void _addRemoveSelectedList(UserInfo contact, bool add) {
    if (add == true) {
      widget.selectedUsers.add(contact);
    } else {
      widget.selectedUsers.remove(contact);
    }
  }

  Widget _getParticipantsList() {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
        height: 4.0,
        color: Colors.grey,
      ),
      itemCount: _contactList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            '${_contactList[index].name}',
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            '${_contactList[index].statusMsg}',
            overflow: TextOverflow.ellipsis,
          ),
          trailing: widget.actionRequired == ContactListAction.Select
              ? Checkbox(
                  value: _isSelected(_contactList[index]),
                  onChanged: (value) {
                    if (this.mounted) {
                      setState(() {
                        _addRemoveSelectedList(_contactList[index], value);
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
                      _addRemoveSelectedList(_contactList[index],
                          !_isSelected(_contactList[index]));
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
        widget.selectedUsers.length > 0
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

  _isSelected(UserInfo contact) {
    return widget.selectedUsers.indexOf(contact) > -1 ? true : false;
  }
}

class Contact {
  int id;
  String name;
  String statusMsg;
  String image;
  int createdAt;
  int updatedAt;
  bool selected;

  Contact(
      {this.id,
      this.name,
      this.statusMsg,
      this.image,
      this.createdAt,
      this.updatedAt,
      this.selected = false});
}
