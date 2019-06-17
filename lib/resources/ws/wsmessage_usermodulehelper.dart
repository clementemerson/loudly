import 'dart:convert';

import 'package:loudly/resources/contacts/contacts_helper.dart';
import 'package:loudly/resources/ws/message_models/general_message_format.dart';
import 'package:loudly/resources/ws/message_models/userinfo_message.dart';
import 'package:loudly/resources/ws/websocket.dart';
import 'package:loudly/resources/ws/websocket_messagemodules.dart';

class WebSocketUsersModuleHelper {
//Event List
  static const String getUsersFromPhoneNumbers_event =
      'getUsersFromPhoneNumbers';
  static const String getGroups_event = 'getGroups';

  static Future<int> getUsersFromPhoneNumbers(List<String> phoneNumbers) async {
    int messageid = await WebSocketMessageModules.getNextMessageId();
    try {
      var message = {
        'module': WebSocketMessageModules.userModule,
        'event': getUsersFromPhoneNumbers_event,
        'messageid': messageid,
        'phoneNumbers': phoneNumbers
      };
      WebSocketListener().sendMessage(json.encode(message));
    } catch (Exception) {
      throw Exception('Failed to send message to server via websocket');
    }
    return messageid;
  }

  static Future<int> getGroups() async {
    int messageid = await WebSocketMessageModules.getNextMessageId();
    try {
      var message = {
        'module': WebSocketMessageModules.userModule,
        'event': getGroups_event,
        'messageid': messageid
      };
      WebSocketListener().sendMessage(json.encode(message));
    } catch (Exception) {
      throw Exception('Failed to send message to server via websocket');
    }
    return messageid;
  }

  static void onReceivedMessage(GeneralMessageFormat genFormatMessage) {
    switch (genFormatMessage.event) {
      case getUsersFromPhoneNumbers_event:
        onReceivedUsersFromPhoneNumbers(genFormatMessage);
        break;
      case getGroups_event:
        onReceivedGroups(genFormatMessage);
        break;
    }
  }

  static void onReceivedUsersFromPhoneNumbers(
      GeneralMessageFormat genFormatMessage) {
    try {
      print(genFormatMessage);
      List<UserInfoDB> userInfo = userInfoFromJson(genFormatMessage.data.toString());
      ContactsHelper.createLoudlyContacts(userInfo);
    } catch (Exception) {
      throw Exception('Failed to parse message from server');
    }
  }

  static void onReceivedGroups(GeneralMessageFormat genFormatMessage) {
    try {
      print(genFormatMessage);
    } catch (Exception) {
      throw Exception('Failed to parse message from server');
    }
  }
}
