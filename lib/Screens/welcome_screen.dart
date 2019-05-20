import 'package:flutter/material.dart';
import 'package:loudly/Screens/phonelogin_screen.dart';
import 'package:loudly/project_settings.dart';
import 'package:loudly/project_styles.dart';
import 'package:loudly/platform_widgets.dart';

class WelcomeScreen extends StatefulWidget {
  static final String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    //TODO1: check whether the device has valid credentials, if yes goto home_screen, else goto phonelogin_screen

    //Mock Code
    new Future.delayed(new Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, PhoneLoginScreen.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              kProjectIcon,
              size: kIcon_Big,
            ),
            Text(
              kProjectName,
              style: TextStyle(
                fontSize: kText_Big,
              ),
            ),
            kGetActivityIndicator(),
          ],
        ),
      ),
    );
  }
}
