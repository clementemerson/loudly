import 'package:flutter/material.dart';
import 'package:loudly/resources/ws/message_models/general_message_format.dart';

import 'network_helper.dart';

class LoginService {
  //static String serverName = 'https://loudly.loudspeakerdev.net';
  static String serverName = 'http://127.0.0.1:8081';
  //static String serverName = 'http://10.0.2.2:8081';

  static Future<String> getOTP({@required String phoneNumber}) async {
    String sessionId = '';
    try {
      String requestUrl = serverName + '/getotp/$phoneNumber';

      dynamic data = await RestAPIHelper.getData(url: requestUrl);
      if (data != null && data[GeneralMessageFormat.jsonStatus] == 'Success') {
        sessionId = data['Details'];
      } else {
        throw Exception('OTP not generated');
      }
    } catch (Exception) {
      throw Exception('OTP not generated');
    }

    return sessionId;
  }

  static Future<dynamic> verifyOTP(
      {@required String otp, @required String sessionId}) async {
    dynamic result;
    try {
      String requestUrl = serverName + '/signin';
      dynamic body = {"sessionid": sessionId, "otp": otp};

      dynamic data = await RestAPIHelper.postData(url: requestUrl, body: body);
      if (data != null && data[GeneralMessageFormat.jsonStatus] == 'Success') {
        result = data['Details'];
      } else {
        throw Exception('Failed to verify OTP');
      }
    } catch (Exception) {
      throw Exception('Failed to verify OTP');
    }

    return result;
  }
}
