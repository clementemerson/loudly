import 'package:flutter/material.dart';
import 'package:loudly/data/database.dart';
import 'package:loudly/resources/contacts/contacts_helper.dart';
import 'package:loudly/resources/ws/event_handlers/groupmodule.dart';
import 'package:loudly/resources/ws/event_handlers/pollmodule.dart';
import 'package:loudly/resources/ws/event_handlers/usermodule.dart';
import 'package:phone_number/phone_number.dart';

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

    await _getGroups();
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
    await WSUsersModule.getUsersFromPhoneNumbers(phoneNumbers, callback: () {
      return;
    });
  }

  Future<void> _getGroups() async {
    await WSUsersModule.getGroups(callback: () {
      return;
    });
  }

  Future<void> _getPolls() async {
    await WSUsersModule.getPolls(callback: () {
      return;
    });
  }

  Future<void> _getGroupsInfo() async {
    List<String> groupids;
    await WSGroupsModule.getInfo(groupids, callback: () {
      return;
    });
  }

  Future<void> _getUsersOfGroup() async {
    BigInt groupid;
    await WSGroupsModule.getUsersOfGroup(groupid, callback: () {
      return;
    });
  }

  Future<void> _getUsersInfo() async {
    List<String> userids;
    await WSUsersModule.getInfo(userids, callback: () {
      return;
    });
  }

  Future<void> _getPollsInfo() async {
    List<String> pollids;
    await WSPollsModule.getInfo(pollids, callback: () {
      return;
    });
  }

}
