import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:loudly/project_enums.dart';

class ContactList extends StatefulWidget {
  final ContactListType contactListType;
  final String groupId;

  ContactList({@required this.contactListType, this.groupId});

  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  List<Contact> _contactList = [];

  @override
  void initState() {
    getContactsData();

    super.initState();
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
        for (var groupData in decodedData) {
          Contact group = new Contact(
              id: groupData['id'],
              name: groupData['name'],
              statusMsg: groupData['statusmsg'],
              image: groupData['image']);

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

  @override
  Widget build(BuildContext context) {
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
          leading: Image.network(_contactList[index].image),
        );
      },
    );
  }
}

class Contact {
  int id;
  String name;
  String statusMsg;
  String image;
  int createdAt;
  int updatedAt;

  Contact(
      {this.id,
      this.name,
      this.statusMsg,
      this.image,
      this.createdAt,
      this.updatedAt});
}
