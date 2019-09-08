import 'package:flutter/material.dart';
import 'package:loudly/project_textconstants.dart';
import 'package:loudly/resources/phone_services/secure_storage.dart';

import 'package:loudly/resources/ws/websocket.dart';
import 'package:loudly/ui/Screens/home_screen.dart';
import 'package:loudly/ui/Screens/phonelogin_screen.dart';
import 'package:loudly/project_settings.dart';
import 'package:loudly/project_styles.dart';
import 'package:loudly/platform_widgets.dart';
import 'package:loudly/ui/globals.dart';

class WelcomeScreen extends StatefulWidget {
  static final String route = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    //TODO1: check whether the device has valid credentials, if yes goto home_screen, else goto phonelogin_screen
    checkForCredentials();
  }

  checkForCredentials() async {
    final String token =  await SecureStorage().read(key: jwtToken);
    final String userId =  await SecureStorage().read(key: selfUser);
    
    if (userId != null) Globals.selfUserId = int.parse(userId);
    print(Globals.selfUserId);

    await WebSocketHelper()
        .initConnection(token: token, initCallback: setupWebSocketConnection);
    if (WebSocketHelper().connectionEstablished == false) {
      Navigator.pushReplacementNamed(context, PhoneLoginScreen.route);
    }
  }

  setupWebSocketConnection(bool connectionEstablished) {
    if (connectionEstablished == true) {
      Navigator.pushNamedAndRemoveUntil(
          context, HomeScreen.route, (Route<dynamic> route) => false);
    } else {
      Navigator.pushReplacementNamed(context, PhoneLoginScreen.route);
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
              projectIcon,
              size: kIcon_Big,
              color: Colors.blue,
            ),
            Text(
              projectName,
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
