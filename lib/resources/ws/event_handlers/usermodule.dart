import 'dart:convert';

import 'package:loudly/resources/contacts/contacts_helper.dart';
import 'package:loudly/resources/ws/message_models/general_message_format.dart';
import 'package:loudly/resources/ws/message_models/userinfo_message.dart';
import 'package:loudly/resources/ws/websocket.dart';
import 'package:loudly/resources/ws/wsutility.dart';

class WSUsersModule {
//Event List
  static const String getUsersFromPhoneNumbersEvent =
      'getUsersFromPhoneNumbers';
  static const String getGroupsEvent = 'getGroups';
  static const String getPollsEvent = 'getPolls';
  static const String getInfoEvent = 'getInfo';

  static Future<int> getUsersFromPhoneNumbers(List<String> phoneNumbers,
      {Function callback}) async {
    try {
      int messageid = await WSUtility.getNextMessageId();
      var message = {
        'module': WSUtility.userModule,
        'event': getUsersFromPhoneNumbersEvent,
        'messageid': messageid,
        'phoneNumbers': phoneNumbers
      };
      WebSocketHelper().sendMessage(message, callback: callback);
      return messageid;
    } catch (Exception) {
      throw Exception('Failed to send message to server via websocket');
    }
  }

  static Future<int> getGroups({Function callback}) async {
    try {
      int messageid = await WSUtility.getNextMessageId();
      var message = {
        'module': WSUtility.userModule,
        'event': getGroupsEvent,
        'messageid': messageid
      };
      WebSocketHelper().sendMessage(json.encode(message), callback: callback);
      return messageid;
    } catch (Exception) {
      throw Exception('Failed to send message to server via websocket');
    }
  }

  static Future<int> getPolls({Function callback}) async {
    try {
      int messageid = await WSUtility.getNextMessageId();
      Message message = Message(
          module: WSUtility.userModule,
          event: getPollsEvent,
          messageid: messageid);
      WebSocketHelper().sendMessage(message.toJson(), callback: callback);
      return messageid;
    } catch (Exception) {
      throw Exception('Failed to send message to server via websocket');
    }
  }

  static Future<int> getInfo(List<String> userids, {Function callback}) async {
    try {
      int messageid = await WSUtility.getNextMessageId();
      Message message = Message(
          module: WSUtility.userModule,
          event: getInfoEvent,
          messageid: messageid,
          data: {'userids': userids});
      WebSocketHelper().sendMessage(message.toJson(), callback: callback);
      return messageid;
    } catch (Exception) {
      throw Exception('Failed to send message to server via websocket');
    }
  }

//----------------------------------------------------------------------------------------------------------------
  static void onMessage(GeneralMessageFormat genFormatMessage) {
    switch (genFormatMessage.message.event) {
      case getUsersFromPhoneNumbersEvent:
        onUsersFromPhoneNumbersReceived(genFormatMessage);
        break;
      case getGroupsEvent:
        onGroupsReceived(genFormatMessage);
        break;
    }
  }

  static void onUsersFromPhoneNumbersReceived(
      GeneralMessageFormat genFormatMessage) {
    try {
      print(genFormatMessage);
      List<UserInfoDB> userInfo =
          userInfoFromList(genFormatMessage.message.data);
      ContactsHelper.createLoudlyContacts(userInfo);
    } catch (Exception) {
      throw Exception('Failed to parse message from server');
    }
  }

  static void onGroupsReceived(GeneralMessageFormat genFormatMessage) {
    try {
      print(genFormatMessage);
    } catch (Exception) {
      throw Exception('Failed to parse message from server');
    }
  }
}
