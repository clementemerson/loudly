import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(kProjectName),
      ),
      body: Container(
        padding: const EdgeInsets.all(40.0),
        child: ListView(
          children: <Widget>[
            kUserInputNumberTextField(
                helperText: kEnterMobileNumberTxt, maxLen: 10),
            kSizedBox_Medium,
            RaisedButton(
              child: Text(kLoginRegister),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  PhoneVerifyScreen.id,
                );
              },
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
