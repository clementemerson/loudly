import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'network_helper.dart';

class LoginService {
  //static String serverName = 'https://loudly.loudspeakerdev.net';
  static String serverName = 'http://10.0.2.2:8081';

  static Future<String> getOTP({@required String phoneNumber}) async {
    String sessionId = '';
    try {
      String requestUrl = serverName + '/getotp/$phoneNumber';

      dynamic data = await NetworkHelper.getData(url: requestUrl);
      print(data);
      if (data != null && data['Status'] == 'Success') {
        sessionId = data['Details'];
      } else {
        throw Exception('OTP not generated');
      }
    } catch (Exception) {
      throw Exception('OTP not generated');
    }

    return sessionId;
  }

  static Future<String> verifyOTP(
      {@required String otp, @required String sessionId}) async {
    String token = '';
    try {
      String requestUrl = serverName + '/signin';
      dynamic body = {"sessionid": sessionId, "otp": otp};

      dynamic data = await NetworkHelper.postData(url: requestUrl, body: body);
      print(data);
      if (data != null && data['Status'] == 'Success') {
        token = data['Details'];
      } else {
        throw Exception('Failed to verify OTP');
      }
    } catch (Exception) {
      throw Exception('Failed to verify OTP');
    }

    return token;
  }
}
