import 'package:loudly/Models/groupuser.dart';
import 'package:loudly/Models/userinfo.dart';
import 'package:loudly/Models/userpoll.dart';
import 'package:loudly/resources/ws/message_models/general_message_format.dart';
import 'package:loudly/resources/ws/message_store.dart';
import 'package:loudly/resources/ws/websocket.dart';
import 'package:loudly/resources/ws/wsutility.dart';

class WSUsersModule {
//Event List
  static const String getUsersFromPhoneNumbersEvent =
      'getUsersFromPhoneNumbers';
  static const String getGroupsEvent = 'getGroups';
  static const String getPollsEvent = 'getPolls';
  static const String getInfoEvent = 'getInfo';
  static const String changeNameEvent = 'changeName';
  static const String changeStatusEvent = 'changeStatusMsg';

  static Future<int> getUsersFromPhoneNumbers(List<String> phoneNumbers,
      {Function callback}) async {
    try {
      int messageid = await WSUtility.getNextMessageId();
      Message message = Message(
          module: WSUtility.userModule,
          event: getUsersFromPhoneNumbersEvent,
          messageid: messageid,
          data: {'phoneNumbers': phoneNumbers});
      MessageStore().add(message);

      WebSocketHelper().sendMessage(message.toJson(), callback: callback);
      return messageid;
    } catch (Exception) {
      throw Exception('Failed to send message to server via websocket');
    }
  }

  static Future<int> getGroups({Function callback}) async {
    try {
      int messageid = await WSUtility.getNextMessageId();
      Message message = Message(
          module: WSUtility.userModule,
          event: getGroupsEvent,
          messageid: messageid);
      MessageStore().add(message);

      WebSocketHelper().sendMessage(message.toJson(), callback: callback);
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
      MessageStore().add(message);

      WebSocketHelper().sendMessage(message.toJson(), callback: callback);
      return messageid;
    } catch (Exception) {
      throw Exception('Failed to send message to server via websocket');
    }
  }

  static Future<int> getInfo(List<int> userids, {Function callback}) async {
    try {
      int messageid = await WSUtility.getNextMessageId();
      Message message = Message(
          module: WSUtility.userModule,
          event: getInfoEvent,
          messageid: messageid,
          data: {'userids': userids});
      MessageStore().add(message);

      WebSocketHelper().sendMessage(message.toJson(), callback: callback);
      return messageid;
    } catch (Exception) {
      throw Exception('Failed to send message to server via websocket');
    }
  }

  static Future<int> changeName(String name, {Function callback}) async {
    try {
      int messageid = await WSUtility.getNextMessageId();
      Message message = Message(
          module: WSUtility.userModule,
          event: changeNameEvent,
          messageid: messageid,
          data: {'name': name});
      MessageStore().add(message);

      WebSocketHelper().sendMessage(message.toJson(), callback: callback);
      return messageid;
    } catch (Exception) {
      throw Exception('Failed to send message to server via websocket');
    }
  }

  static Future<int> changeStatusMsg(String statusmsg,
      {Function callback}) async {
    try {
      int messageid = await WSUtility.getNextMessageId();
      Message message = Message(
          module: WSUtility.userModule,
          event: changeStatusEvent,
          messageid: messageid,
          data: {'statusmsg': statusmsg});
      MessageStore().add(message);

      WebSocketHelper().sendMessage(message.toJson(), callback: callback);
      return messageid;
    } catch (Exception) {
      throw Exception('Failed to send message to server via websocket');
    }
  }

//----------------------------------------------------------------------------------------------------------------
  static void onMessage(
      GeneralMessageFormat genFormatMessage, Message sentMessage) {
    switch (genFormatMessage.message.event) {
      case getUsersFromPhoneNumbersEvent:
        onUsersFromPhoneNumbersReply(genFormatMessage);
        break;
      case getGroupsEvent:
        onGroupsReply(genFormatMessage);
        break;
      case getPollsEvent:
        onPollsReply(genFormatMessage);
        break;
      case getInfoEvent:
        onInfoReply(genFormatMessage);
        break;
    }
  }

  static void onUsersFromPhoneNumbersReply(
      GeneralMessageFormat genFormatMessage) {
    try {
      print(genFormatMessage);
      List<UserInfo> userInfoList =
          userInfoFromList(genFormatMessage.message.data);
      for (UserInfo userInfo in userInfoList) {
        UserInfo.insert(userInfo);
      }
    } catch (Exception) {
      throw Exception('Failed to parse message from server');
    }
  }

  static void onGroupsReply(GeneralMessageFormat genFormatMessage) {
    try {
      print(genFormatMessage);
      List<GroupUser> groupUserList =
          groupUserFromList(genFormatMessage.message.data);
      for (GroupUser groupUser in groupUserList) {
        GroupUser.insert(groupUser);
      }
    } catch (Exception) {
      throw Exception('Failed to parse message from server');
    }
  }

  static void onPollsReply(GeneralMessageFormat genFormatMessage) {
    try {
      print(genFormatMessage);
      List<UserPoll> userPollList =
          userPollFromList(genFormatMessage.message.data);
      for (UserPoll userPoll in userPollList) {
        UserPoll.insert(userPoll);
      }
    } catch (Exception) {
      throw Exception('Failed to parse message from server');
    }
  }

  static void onInfoReply(GeneralMessageFormat genFormatMessage) {
    try {
      print(genFormatMessage);
      List<UserInfo> userInfoList =
          userInfoFromList(genFormatMessage.message.data);
      for (UserInfo userInfo in userInfoList) {
        UserInfo.insert(userInfo);
      }
    } catch (Exception) {
      throw Exception('Failed to parse message from server');
    }
  }
}
