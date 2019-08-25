import 'package:flutter/widgets.dart';
import 'package:loudly/models/group_user_model.dart';
import 'package:loudly/models/user_info_model.dart';
import 'package:loudly/models/user_poll_model.dart';
import 'package:loudly/project_textconstants.dart';
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
      throw Exception(sendingWSMessageFailed);
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
      throw Exception(sendingWSMessageFailed);
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
      throw Exception(sendingWSMessageFailed);
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
      throw Exception(sendingWSMessageFailed);
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
      throw Exception(sendingWSMessageFailed);
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
      throw Exception(sendingWSMessageFailed);
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
      List<UserInfoModel> userInfoList =
          userInfoFromList(genFormatMessage.message.data);
      for (UserInfoModel userInfo in userInfoList) {
        await UserInfoModel.insert(userInfo);
      }
    } catch (Exception) {
      throw Exception(parsingWSMessageFailed);
    }
  }

  static Future<void> getGroupsReply(
      GeneralMessageFormat genFormatMessage) async {
    try {
      List<GroupUserModel> groupUserList =
          groupUserFromList(genFormatMessage.message.data);
      for (GroupUserModel groupUser in groupUserList) {
        await GroupUserModel.insert(groupUser);
      }
    } catch (Exception) {
      throw Exception(parsingWSMessageFailed);
    }
  }

  static Future<void> getPollsReply(
      GeneralMessageFormat genFormatMessage) async {
    try {
      List<UserPollModel> userPollList =
          userPollFromList(genFormatMessage.message.data);
      for (UserPollModel userPoll in userPollList) {
        await UserPollModel.insert(userPoll);
      }
    } catch (Exception) {
      throw Exception(parsingWSMessageFailed);
    }
  }

  static Future<void> getInfoReply(
      GeneralMessageFormat genFormatMessage) async {
    try {
      List<UserInfoModel> userInfoList =
          userInfoFromList(genFormatMessage.message.data);
      for (UserInfoModel userInfo in userInfoList) {
        await UserInfoModel.insert(userInfo);
      }
    } catch (Exception) {
      throw Exception(parsingWSMessageFailed);
    }
  }

  static Future<void> changeNameReply(GeneralMessageFormat genFormatMessage,
      {@required Message sentMessage}) async {
    try {
      //Prepare data
      dynamic data = {
        'user_id': Globals.selfUserId,
        'name': sentMessage.data['name']
      };
      await UserInfoModel.update(data);
    } catch (Exception) {
      throw Exception(parsingWSMessageFailed);
    }
  }

  static Future<void> changeStatusMsgReply(
      GeneralMessageFormat genFormatMessage,
      {@required Message sentMessage}) async {
    try {
      dynamic data = {
        'user_id': Globals.selfUserId,
        'statusmsg': sentMessage.data['statusmsg']
      };
      await UserInfoModel.update(data);
    } catch (Exception) {
      throw Exception(parsingWSMessageFailed);
    }
  }
}
