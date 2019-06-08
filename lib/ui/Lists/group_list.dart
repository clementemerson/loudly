import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:loudly/ui/Screens/grouppolllist_screen.dart';

class GroupList extends StatefulWidget {
  @override
  _GroupListState createState() => _GroupListState();
}

class _GroupListState extends State<GroupList> {
  List<Group> _groupList = [];

  @override
  void initState() {
    getGroupData();

    super.initState();
  }

  getGroupData() async {
    List<String> urls = [];
    urls.add('https://my.api.mockaroo.com/groups.json?key=17d9cc40');
    urls.add('https://my.api.mockaroo.com/groups.json?key=3b82acd0');
    urls.add('https://my.api.mockaroo.com/groups.json?key=873a3a70');

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
          Group group = new Group(
              id: groupData['id'],
              name: groupData['name'],
              latestPollTitle: groupData['latestpolltitle'],
              createdBy: groupData['createdby'],
              image: groupData['image']);

          if (this.mounted == true) {
            setState(() {
              _groupList.add(group);
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
      itemCount: _groupList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            '${_groupList[index].name}',
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            '${_groupList[index].latestPollTitle}',
            overflow: TextOverflow.ellipsis,
          ),
          leading: Image.network(_groupList[index].image),
          onTap: () {
            Navigator.pushNamed(
              context,
              GroupPollListScreen.id,
            );
          },
        );
      },
    );
  }
}

class Group {
  String id;
  String name;
  String latestPollTitle;
  String createdBy;
  int createdAt;
  int updatedAt;
  String image;

  Group(
      {this.id,
      this.name,
      this.latestPollTitle,
      this.createdBy,
      this.createdAt,
      this.updatedAt,
      this.image});
}
