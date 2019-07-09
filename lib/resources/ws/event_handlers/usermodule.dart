import 'package:flutter/widgets.dart';
import 'package:loudly/models/groupuser.dart';
import 'package:loudly/models/userinfo.dart';
import 'package:loudly/models/userpoll.dart';
import 'package:loudly/resources/ws/message_models/general_message_format.dart';
import 'package:loudly/resources/ws/message_store.dart';
import 'package:loudly/resources/ws/websocket.dart';
import 'package:loudly/resources/ws/wsutility.dart';
import 'package:loudly/ui/globals.dart';

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
  static Future<void> onMessage(
      GeneralMessageFormat genFormatMessage, Message sentMessage) async {
    switch (genFormatMessage.message.event) {
      case getUsersFromPhoneNumbersEvent:
        await getUsersFromPhoneNumbersReply(genFormatMessage);
        break;
      case getGroupsEvent:
        await getGroupsReply(genFormatMessage);
        break;
      case getPollsEvent:
        await getPollsReply(genFormatMessage);
        break;
      case getInfoEvent:
        await getInfoReply(genFormatMessage);
        break;
      case changeNameEvent:
        await changeNameReply(genFormatMessage, sentMessage: sentMessage);
        break;
      case changeStatusEvent:
        await changeStatusMsgReply(genFormatMessage, sentMessage: sentMessage);
        break;
    }
  }

  static Future<void> getUsersFromPhoneNumbersReply(
      GeneralMessageFormat genFormatMessage) async {
    try {
      List<UserInfo> userInfoList =
          userInfoFromList(genFormatMessage.message.data);
      for (UserInfo userInfo in userInfoList) {
        await UserInfo.insert(userInfo);
      }
    } catch (Exception) {
      throw Exception('Failed to parse message from server');
    }
  }

  static Future<void> getGroupsReply(
      GeneralMessageFormat genFormatMessage) async {
    try {
      List<GroupUser> groupUserList =
          groupUserFromList(genFormatMessage.message.data);
      for (GroupUser groupUser in groupUserList) {
        await GroupUser.insert(groupUser);
      }
    } catch (Exception) {
      throw Exception('Failed to parse message from server');
    }
  }

  static Future<void> getPollsReply(
      GeneralMessageFormat genFormatMessage) async {
    try {
      List<UserPoll> userPollList =
          userPollFromList(genFormatMessage.message.data);
      for (UserPoll userPoll in userPollList) {
        await UserPoll.insert(userPoll);
      }
    } catch (Exception) {
      throw Exception('Failed to parse message from server');
    }
  }

  static Future<void> getInfoReply(GeneralMessageFormat genFormatMessage) async {
    try {
      List<UserInfo> userInfoList =
          userInfoFromList(genFormatMessage.message.data);
      for (UserInfo userInfo in userInfoList) {
        await UserInfo.insert(userInfo);
      }
    } catch (Exception) {
      throw Exception('Failed to parse message from server');
    }
  }

  static Future<void> changeNameReply(GeneralMessageFormat genFormatMessage,
      {@required Message sentMessage}) async {
    try {
      //Prepare data
      dynamic data = {
        'user_id': Globals.self_userid,
        'name': sentMessage.data['name']
      };
      await UserInfo.update(data);
    } catch (Exception) {
      throw Exception('Failed to parse message from server');
    }
  }

  static Future<void> changeStatusMsgReply(GeneralMessageFormat genFormatMessage,
      {@required Message sentMessage}) async {
    try {
      dynamic data = {
        'user_id': Globals.self_userid,
        'statusmsg': sentMessage.data['statusmsg']
      };
      await UserInfo.update(data);
    } catch (Exception) {
      throw Exception('Failed to parse message from server');
    }
  }
}
