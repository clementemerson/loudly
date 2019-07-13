import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
  static const String id = 'phoneverify_screen';

  PhoneVerifyScreen();

  @override
  _PhoneVerifyScreenState createState() => _PhoneVerifyScreenState();
}

class _PhoneVerifyScreenState extends State<PhoneVerifyScreen> {
  String sessionId;
  String otp;

  onPressed() async {
    try {
      dynamic data =
          await LoginService.verifyOTP(sessionId: sessionId, otp: otp);
      String token = data['token'];
      Globals.self_userid = data['user_id'];
      final storage = new FlutterSecureStorage();
      await storage.write(key: 'credential', value: token);
      await storage.write(
          key: 'user_id', value: Globals.self_userid.toString());
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
          context, SetupScreen.id, (Route<dynamic> route) => false);
    } else {
      Navigator.pushReplacementNamed(context, PhoneLoginScreen.id);
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    sessionId = ModalRoute.of(context).settings.arguments;
  }

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
            kUserInputTextField(
                helperText: kEnterOTPTxt,
                maxLen: 6,
                onChanged: (value) {
                  otp = value;
                }),
            kSizedBox_Medium,
            RaisedButton(
              child: Text(kVerifyOTP),
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
