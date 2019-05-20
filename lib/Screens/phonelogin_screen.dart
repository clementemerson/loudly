import 'package:flutter/material.dart';
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _getMobileNumberTextField(),
              kSizedBox_Medium,
              RaisedButton(
                child: Text('Login / Register'),
                onPressed: () {},
              ),
            ],
          ),
        ));
  }

  TextField _getMobileNumberTextField() {
    return TextField(
      maxLength: 10,
      style: TextStyle(
        fontSize: kText_Big,
        letterSpacing: 3.0,
      ),
      decoration: InputDecoration(
        helperText: kEnterMobileNumberTxt,
        prefixIcon: Icon(Icons.phone),
      ),
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.go,
      textAlign: TextAlign.center,
    );
  }
}
