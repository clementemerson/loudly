import 'dart:convert';

import 'package:loudly/Models/groupinfo.dart';
import 'package:loudly/resources/contacts/contacts_helper.dart';
import 'package:loudly/resources/ws/message_models/general_message_format.dart';
import 'package:loudly/resources/ws/message_models/userinfo_message.dart';
import 'package:loudly/resources/ws/websocket.dart';
import 'package:loudly/resources/ws/wsutility.dart';

class WSGroupsModule {
//Event List
  static const String createEvent = 'create';
  static const String getInfoEvent = 'getInfo';
  static const String getUsersOfGroupEvent = 'getUsersOfGroup';
  static const String getPollsEvent = 'getPolls';
  static const String addUserEvent = 'addUser';
  static const String changeTitleEvent = 'changeTitle';
  static const String changeDescEvent = 'changeDesc';
  static const String changeUserPermissionEvent = 'changeUserPermission';
  static const String removeUserEvent = 'removeUser';

  static Future<int> create(GroupInfo groupInfo, {Function callback}) async {
    try {
      int messageid = await WSUtility.getNextMessageId();
      var message = {
        'module': WSUtility.groupModule,
        'event': createEvent,
        'messageid': messageid,
        'data': {'name': groupInfo.name, 'desc': groupInfo.desc}
      };
      WebSocketHelper().sendMessage(message, callback: callback);
      return messageid;
    } catch (Exception) {
      throw Exception('Failed to send message to server via websocket');
    }
  }

  static Future<int> getInfo(List<String> groupids, {Function callback}) async {
    try {
      int messageid = await WSUtility.getNextMessageId();
      var message = {
        'module': WSUtility.groupModule,
        'event': getInfoEvent,
        'messageid': messageid,
        'data': {'groupids': groupids}
      };
      WebSocketHelper().sendMessage(json.encode(message), callback: callback);
      return messageid;
    } catch (Exception) {
      throw Exception('Failed to send message to server via websocket');
    }
  }

  static Future<int> getUsersOfGroup(BigInt groupid,
      {Function callback}) async {
    try {
      int messageid = await WSUtility.getNextMessageId();
      var message = {
        'module': WSUtility.groupModule,
        'event': getUsersOfGroupEvent,
        'messageid': messageid,
        'data': {'groupid': groupid}
      };
      WebSocketHelper().sendMessage(json.encode(message), callback: callback);
      return messageid;
    } catch (Exception) {
      throw Exception('Failed to send message to server via websocket');
    }
  }

  static Future<int> getPolls(BigInt groupid, {Function callback}) async {
    try {
      int messageid = await WSUtility.getNextMessageId();
      var message = {
        'module': WSUtility.groupModule,
        'event': getPollsEvent,
        'messageid': messageid,
        'data': {'groupid': groupid}
      };
      WebSocketHelper().sendMessage(json.encode(message), callback: callback);
      return messageid;
    } catch (Exception) {
      throw Exception('Failed to send message to server via websocket');
    }
  }

  static Future<int> addUser(BigInt groupid, BigInt userid, String permission,
      {Function callback}) async {
    try {
      int messageid = await WSUtility.getNextMessageId();
      var message = {
        'module': WSUtility.groupModule,
        'event': addUserEvent,
        'messageid': messageid,
        'data': {
          'groupid': groupid,
          'user_id': userid,
          'permission': permission
        }
      };
      WebSocketHelper().sendMessage(json.encode(message), callback: callback);
      return messageid;
    } catch (Exception) {
      throw Exception('Failed to send message to server via websocket');
    }
  }

  static Future<int> changeTitle(BigInt groupid, String groupTitle,
      {Function callback}) async {
    try {
      int messageid = await WSUtility.getNextMessageId();
      var message = {
        'module': WSUtility.groupModule,
        'event': changeTitleEvent,
        'messageid': messageid,
        'data': {'groupid': groupid, 'name': groupTitle}
      };
      WebSocketHelper().sendMessage(json.encode(message), callback: callback);
      return messageid;
    } catch (Exception) {
      throw Exception('Failed to send message to server via websocket');
    }
  }

  static Future<int> changeDesc(BigInt groupid, String groupDesc,
      {Function callback}) async {
    try {
      int messageid = await WSUtility.getNextMessageId();
      var message = {
        'module': WSUtility.groupModule,
        'event': changeDescEvent,
        'messageid': messageid,
        'data': {'groupid': groupid, 'desc': groupDesc}
      };
      WebSocketHelper().sendMessage(json.encode(message), callback: callback);
      return messageid;
    } catch (Exception) {
      throw Exception('Failed to send message to server via websocket');
    }
  }

  static Future<int> changeUserPermission(
      BigInt groupid, BigInt userid, String permission,
      {Function callback}) async {
    try {
      int messageid = await WSUtility.getNextMessageId();
      var message = {
        'module': WSUtility.groupModule,
        'event': changeUserPermissionEvent,
        'messageid': messageid,
        'data': {
          'groupid': groupid,
          'user_id': userid,
          'permission': permission
        }
      };
      WebSocketHelper().sendMessage(json.encode(message), callback: callback);
      return messageid;
    } catch (Exception) {
      throw Exception('Failed to send message to server via websocket');
    }
  }

  static Future<int> removeUser(BigInt groupid, BigInt userid,
      {Function callback}) async {
    try {
      int messageid = await WSUtility.getNextMessageId();
      var message = {
        'module': WSUtility.groupModule,
        'event': removeUserEvent,
        'messageid': messageid,
        'data': {'groupid': groupid, 'user_id': userid}
      };
      WebSocketHelper().sendMessage(json.encode(message), callback: callback);
      return messageid;
    } catch (Exception) {
      throw Exception('Failed to send message to server via websocket');
    }
  }

//----------------------------------------------------------------------------------------------------------------------------
  static void onMessage(GeneralMessageFormat genFormatMessage) {
    switch (genFormatMessage.message.event) {
      case createEvent:
        onCreateReply(genFormatMessage);
        break;
      case getInfoEvent:
        onGroupsReply(genFormatMessage);
        break;
      case getUsersOfGroupEvent:
        onGetUsersOfGroupReply(genFormatMessage);
        break;
      case getPollsEvent:
        onGetPollsReply(genFormatMessage);
        break;
      case addUserEvent:
        onAddUserReply(genFormatMessage);
        break;
      case changeTitleEvent:
        onChangeTitleReply(genFormatMessage);
        break;
      case changeDescEvent:
        onChangeDescReply(genFormatMessage);
        break;
      case changeUserPermissionEvent:
        onChangeUserPermissionReply(genFormatMessage);
        break;
      case removeUserEvent:
        onRemoveUserReply(genFormatMessage);
        break;
    }
  }

  static void onCreateReply(GeneralMessageFormat genFormatMessage) {
    try {
      print(genFormatMessage);
      List<UserInfoDB> userInfo =
          userInfoFromList(genFormatMessage.message.data);
      ContactsHelper.createLoudlyContacts(userInfo);
    } catch (Exception) {
      throw Exception('Failed to parse message from server');
    }
  }

  static void onGroupsReply(GeneralMessageFormat genFormatMessage) {
    try {
      print(genFormatMessage);
    } catch (Exception) {
      throw Exception('Failed to parse message from server');
    }
  }

  static void onGetUsersOfGroupReply(GeneralMessageFormat genFormatMessage) {
    try {
      print(genFormatMessage);
    } catch (Exception) {
      throw Exception('Failed to parse message from server');
    }
  }

  static void onGetPollsReply(GeneralMessageFormat genFormatMessage) {
    try {
      print(genFormatMessage);
    } catch (Exception) {
      throw Exception('Failed to parse message from server');
    }
  }

  static void onAddUserReply(GeneralMessageFormat genFormatMessage) {
    try {
      print(genFormatMessage);
    } catch (Exception) {
      throw Exception('Failed to parse message from server');
    }
  }

  static void onChangeTitleReply(GeneralMessageFormat genFormatMessage) {
    try {
      print(genFormatMessage);
    } catch (Exception) {
      throw Exception('Failed to parse message from server');
    }
  }

  static void onChangeDescReply(GeneralMessageFormat genFormatMessage) {
    try {
      print(genFormatMessage);
    } catch (Exception) {
      throw Exception('Failed to parse message from server');
    }
  }

  static void onChangeUserPermissionReply(
      GeneralMessageFormat genFormatMessage) {
    try {
      print(genFormatMessage);
    } catch (Exception) {
      throw Exception('Failed to parse message from server');
    }
  }

  static void onRemoveUserReply(GeneralMessageFormat genFormatMessage) {
    try {
      print(genFormatMessage);
    } catch (Exception) {
      throw Exception('Failed to parse message from server');
    }
  }
}
