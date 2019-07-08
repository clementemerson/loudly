import 'package:flutter/material.dart';
import 'package:loudly/Models/userpoll.dart';
import 'package:loudly/data/database.dart';
import 'package:loudly/models/grouppoll.dart';
import 'package:loudly/models/groupuser.dart';
import 'package:loudly/models/userinfo.dart';
import 'package:loudly/resources/ws/event_handlers/groupmodule.dart';
import 'package:loudly/resources/ws/event_handlers/pollmodule.dart';
import 'package:loudly/resources/ws/event_handlers/usermodule.dart';
import 'package:loudly/ui/globals.dart';

class SetupScreen extends StatefulWidget {
  static const String id = 'setup_screen';

  @override
  _SetupScreenState createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    startSettingUp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Loudly'),
      ),
      body: Container(
        child: Center(
          child: Text('Setup'),
        ),
      ),
    );
  }

  void startSettingUp() async {
    //Create DB tables here
    await DBProvider.db.database;

    await _getLoudlyUsers();

    //await _getGroups();
    // await _getGroupsInfo();
    // await _getUsersOfGroup();
    // await _getUsersInfo();

    // await _getPolls();
    // await _getPollsInfo();

    //Process completed.
  }

  Future<List<String>> _getPhoneNumbersFromDevice() async {
    // List<PhoneContacts> phoneContacts = await ContactsHelper.getPhoneContacts();
    // List<String> phoneNumbers = List<String>();
    // for (var contact in phoneContacts) {
    //   try {
    //     dynamic phoneParsed =
    //         await PhoneNumber.parse(contact.phoneNumber, region: 'IN');
    //     phoneNumbers.add(phoneParsed['e164']);
    //   } catch (Exception) {}
    // }
    // return phoneNumbers;
    List<String> phoneNumbers = List<String>();
    phoneNumbers.add('+919884386484');
    return phoneNumbers;
  }

  Future<void> _getLoudlyUsers() async {
    List<String> phoneNumbers = await _getPhoneNumbersFromDevice();
    await WSUsersModule.getUsersFromPhoneNumbers(phoneNumbers,
        callback: getGroups);
  }

  getGroups() async {
    await WSUsersModule.getGroups(callback: _getPolls);
  }

  _getPolls() async {
    await WSUsersModule.getPolls(callback: _getGroupsInfo);
  }

  _getGroupsInfo() async {
    List<GroupUser> userGroups = await GroupUser.getGroupsOfUser(Globals.self_userid);
    List<int> groupids = List<int>();
    for (GroupUser group in userGroups) {
      print(group.groupid);
      groupids.add(group.groupid);
    }
    await WSGroupsModule.getInfo(groupids, callback: _getUsersOfGroup);
  }

  _getUsersOfGroup() async {
    List<GroupUser> userGroups = await GroupUser.getGroupsOfUser(Globals.self_userid);
    for (GroupUser group in userGroups) {
      //The last function in this loop gets the callback function.
      Function callback = userGroups.length == (userGroups.indexOf(group) + 1)
          ? _getUsersInfo()
          : null;
      await WSGroupsModule.getUsersOfGroup(group.groupid, callback: callback);
    }
  }

  _getUsersInfo() async {
    List<GroupUser> userGroups = await GroupUser.getAll();
    Set<int> userids = new Set<int>();
    userGroups.forEach((userGroup) {
      userids.add(userGroup.userId);
    });

    await WSUsersModule.getInfo(userids.toList(), callback: _getPollsInfo);
  }

  _getPollsInfo() async {
    List<UserPoll> polllist = await UserPoll.getAll();
    Set<int> pollids = new Set<int>();
    polllist.forEach((poll) {
      pollids.add(poll.pollid);
    });

    List<int> groupPollList = await GroupPoll.getAll();
    pollids.addAll(groupPollList);
    
    await WSPollsModule.getInfo(pollids.toList(), callback: _onCompleted);
  }

  _onCompleted() {
    print('completed');
  }
}
