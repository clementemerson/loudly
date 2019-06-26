import 'package:flutter/material.dart';
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
    List<String> phoneNumbers = await getPhoneNumbersFromDevice();
    getLoudlyUsers(phoneNumbers);
  }

  Future<List<String>> getPhoneNumbersFromDevice() async {
    List<PhoneContacts> phoneContacts = await ContactsHelper.getPhoneContacts();
    List<String> phoneNumbers = List<String>();
    for (var contact in phoneContacts) {
      try {
        dynamic phoneParsed =
            await PhoneNumber.parse(contact.phoneNumber, region: 'IN');
        phoneNumbers.add(phoneParsed['e164']);
      } catch (Exception) {}
    }
    return phoneNumbers;
  }

  getLoudlyUsers(List<String> phoneNumbers) {
    WSUsersModule.getUsersFromPhoneNumbers(phoneNumbers,
        callback: getLoudlyUsersCompleted);
  }

  getLoudlyUsersCompleted() {
    WSUsersModule.getGroups(callback: getGroupsCompleted);
  }

  getGroupsCompleted() {
    WSUsersModule.getPolls(callback: getPollsCompleted);
  }

  getPollsCompleted() {
    List<String> groupids;
    WSGroupsModule.getInfo(groupids, callback: getGroupInfoCompleted);
  }

  getGroupInfoCompleted() {
    BigInt groupid;
    WSGroupsModule.getUsersOfGroup(groupid, callback: getUsersOfGroupCompleted);
  }

  getUsersOfGroupCompleted() {
    List<String> userids;
    WSUsersModule.getInfo(userids, callback: getUserInfoCompleted);
  }

  getUserInfoCompleted() {
    List<String> pollids;
    WSPollsModule.getInfo(pollids, callback: getPollInfoCompleted);
  }

  getPollInfoCompleted() {
    //completed
  }
}
