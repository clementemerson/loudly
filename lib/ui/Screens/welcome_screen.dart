import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:loudly/resources/ws/websocket.dart';
import 'package:loudly/ui/Screens/home_screen.dart';
import 'package:loudly/ui/Screens/phonelogin_screen.dart';
import 'package:loudly/project_settings.dart';
import 'package:loudly/project_styles.dart';
import 'package:loudly/platform_widgets.dart';
import 'package:loudly/ui/Screens/phoneverify_screen.dart';

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
    checkToken();
    new Future.delayed(new Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, PhoneLoginScreen.id);
    });
  }

  checkToken() async {
    final storage = new FlutterSecureStorage();
    String token = await storage.read(key: 'token');
    print(token);
    WebSocketHelper().initConnection(token: token);
    if (WebSocketHelper().isConnectionEstablished == true) {
      Navigator.pushReplacementNamed(context, HomeScreen.id);
    } else {
      Navigator.pushReplacementNamed(context, PhoneLoginScreen.id);
    }
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
              color: Colors.blue,
            ),
            Text(
              kProjectName,
              style: TextStyle(
                fontSize: kText_Big,
                color: Colors.blue,
              ),
            ),
            kGetActivityIndicator(),
          ],
        ),
      ),
    );
  }
}
