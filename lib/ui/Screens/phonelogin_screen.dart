import 'package:flutter/material.dart';
import 'package:loudly/resources/rest/login_service.dart';
import 'package:loudly/ui/Screens/phoneverify_screen.dart';
import 'package:loudly/common_widgets.dart';
import 'package:loudly/project_settings.dart';
import 'package:loudly/project_styles.dart';
import 'package:loudly/project_textconstants.dart';

class PhoneLoginScreen extends StatefulWidget {
  static const String id = 'phonelogin_screen';

  @override
  _PhoneLoginScreenState createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  String phoneNumber;

  onPressed() async {
    phoneNumber = '+91$phoneNumber';
    String sessionId = await LoginService.getOTP(phoneNumber: phoneNumber);
    Navigator.pushNamed(
      context,
      PhoneVerifyScreen.id,
      arguments: sessionId
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(projectName),
      ),
      body: Container(
        padding: const EdgeInsets.all(40.0),
        child: ListView(
          children: <Widget>[
            kUserInputTextField(
                helperText: enterMobileNumberTxt,
                maxLen: 10,
                onChanged: (value) {
                  phoneNumber = value;
                }),
            kSizedBox_Medium,
            RaisedButton(
              child: Text(loginRegister),
              onPressed: onPressed,
              color: Colors.blue,
              padding: EdgeInsets.all(15.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
