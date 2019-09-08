import 'package:flutter/material.dart';
import 'package:loudly/resources/phone_services/secure_storage.dart';

import 'package:loudly/resources/rest/login_service.dart';
import 'package:loudly/resources/ws/websocket.dart';
import 'package:loudly/common_widgets.dart';
import 'package:loudly/project_settings.dart';
import 'package:loudly/project_styles.dart';
import 'package:loudly/project_textconstants.dart';
import 'package:loudly/ui/Screens/phonelogin_screen.dart';
import 'package:loudly/ui/Screens/setup_screen.dart';
import 'package:loudly/ui/globals.dart';

class PhoneVerifyScreen extends StatefulWidget {
  static final String route = 'phoneverify_screen';

  PhoneVerifyScreen();

  @override
  _PhoneVerifyScreenState createState() => _PhoneVerifyScreenState();
}

class _PhoneVerifyScreenState extends State<PhoneVerifyScreen> {
  String sessionId;
  String otp;

  AppBar _getAppBar() {
    return AppBar(
      title: Text(projectName),
    );
  }

  onPressed() async {
    try {
      dynamic data =
          await LoginService.verifyOTP(sessionId: sessionId, otp: otp);
      String token = data['token'];
      Globals.selfUserId = data['user_id'];
      await SecureStorage().write(key: jwtToken, value: token);
      await SecureStorage().write(key: selfUser, value: Globals.selfUserId.toString());
      
      WebSocketHelper()
          .initConnection(token: token, initCallback: setupWebSocketConnection);

      //Navigator.pushNamed(context, SetupScreen.id);
    } catch (Exception) {
      print(Exception);
    }
  }

  setupWebSocketConnection(bool connectionEstablished) {
    if (connectionEstablished == true) {
      Navigator.pushNamedAndRemoveUntil(
          context, SetupScreen.route, (Route<dynamic> route) => false);
    } else {
      Navigator.pushReplacementNamed(context, PhoneLoginScreen.route);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    sessionId = ModalRoute.of(context).settings.arguments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getAppBar(),
      body: Container(
        padding: const EdgeInsets.all(40.0),
        child: ListView(
          children: <Widget>[
            kUserInputTextField(
                helperText: enterOTPTxt,
                maxLen: 6,
                onChanged: (value) {
                  otp = value;
                }),
            kSizedBox_Medium,
            RaisedButton(
              child: Text(verifyOTP),
              onPressed: onPressed,
              // onPressed: () {
              //   Navigator.of(context).pushNamedAndRemoveUntil(
              //       HomeScreen.id, (Route<dynamic> route) => false);
              // },
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
