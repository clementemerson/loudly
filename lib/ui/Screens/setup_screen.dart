import 'package:flutter/material.dart';
import 'package:loudly/data/database.dart';
import 'package:loudly/models/group_info_model.dart';
import 'package:loudly/project_settings.dart';
import 'package:loudly/resources/phone_services/contacts_helper.dart';
import 'package:loudly/resources/ws/event_handlers/groupmodule.dart';
import 'package:loudly/resources/ws/event_handlers/pollmodule.dart';
import 'package:loudly/resources/ws/event_handlers/usermodule.dart';
import 'package:loudly/ui/Screens/home_screen.dart';
import 'package:phone_number/phone_number.dart';

class SetupScreen extends StatefulWidget {
  static final String route = 'setup_screen';

  @override
  _SetupScreenState createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  @override
  void initState() {
    super.initState();

    startSettingUp();
  }

  AppBar _getAppBar() {
    return AppBar(
      title: Text(projectName),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getAppBar(),
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
  }

  Future<List<String>> _getPhoneNumbersFromDevice() async {
    // List<PhoneContacts> phoneContacts = await ContactsHelper.getPhoneContacts();
    // List<String> phoneNumbers = List<String>();
    // for (var contact in phoneContacts) {
    //   try {
    //     dynamic phoneParsed =
    //         await PhoneNumber.parse(contact.phoneNumber, region: 'IN');
    //     phoneNumbers.add(phoneParsed['e164'].toString());
    //   } catch (Exception) {}
    // }
    // print(phoneNumbers);
    // return phoneNumbers;
    List<String> numbers = List<String>();
    numbers.add('+919884386484');
    numbers.add('+919884091628');
    return numbers;
  }

  Future<void> _getLoudlyUsers() async {
    List<String> phoneNumbers = await _getPhoneNumbersFromDevice();
    await WSUsersModule.getUsersFromPhoneNumbers(phoneNumbers,
        callback: _getMyGroupsInfo);
  }

  _getMyGroupsInfo() async {
    await WSGroupsModule.getMyGroupsInfo(callback: _getMyPollsInfo);
  }

  _getMyPollsInfo() async {
    await WSPollsModule.getMyPollsInfo(callback: _getMyVotes);
  }

  _getMyVotes() async {
    await WSPollsModule.getMyVotesInfo(callback: _getUsersAndPollsOfGroup);
  }

  _getUsersAndPollsOfGroup() async {
    List<GroupInfoModel> userGroups = await GroupInfoModel.getAll();
    if (userGroups.isEmpty) _onCompleted();

    for (GroupInfoModel group in userGroups) {
      //The last function in this loop gets the callback function.
      Function callback = userGroups.length == (userGroups.indexOf(group) + 1)
          ? _onCompleted
          : null;
      await WSGroupsModule.getUsersOfGroup(group.groupid);
      await WSGroupsModule.getPolls(group.groupid, callback: callback);
    }
  }

  _onCompleted() {
    print('completed');
    Navigator.pushNamedAndRemoveUntil(
        context, HomeScreen.route, (Route<dynamic> route) => false);
  }
}
