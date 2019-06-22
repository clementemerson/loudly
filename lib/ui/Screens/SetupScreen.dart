import 'package:flutter/material.dart';
import 'package:loudly/resources/contacts/contacts_helper.dart';
import 'package:loudly/resources/ws/wsmessage_usermodulehelper.dart';
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
    //ContactsHelper.getPhoneContacts().then((phoneContacts) async {
    List<String> phoneContacts = List<String>();
    phoneContacts.add('9884386484');
    List<String> phoneNumbers = List<String>();
    for (var contact in phoneContacts) {
      try {
        dynamic phoneParsed = await PhoneNumber.parse(contact, region: 'IN');
        phoneNumbers.add(phoneParsed['e164']);
      } catch (Exception) {}
    }
    WebSocketUsersModuleHelper.getUsersFromPhoneNumbers(phoneNumbers);
    //});
  }
}
