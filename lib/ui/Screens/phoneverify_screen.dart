import 'package:flutter/material.dart';
import 'package:loudly/ui/Screens/home_screen.dart';
import 'package:loudly/common_widgets.dart';
import 'package:loudly/project_settings.dart';
import 'package:loudly/project_styles.dart';
import 'package:loudly/project_textconstants.dart';

class PhoneVerifyScreen extends StatefulWidget {
  static const String id = 'phoneverify_screen';

  final String sSessionId;

  PhoneVerifyScreen({this.sSessionId});

  @override
  _PhoneVerifyScreenState createState() => _PhoneVerifyScreenState();
}

class _PhoneVerifyScreenState extends State<PhoneVerifyScreen> {
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
                helperText: kEnterOTPTxt, maxLen: 6),
            kSizedBox_Medium,
            RaisedButton(
              child: Text(kVerifyOTP),
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    HomeScreen.id, (Route<dynamic> route) => false);
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
