import 'package:flutter/widgets.dart';
import 'package:loudly/Models/groupinfo.dart';
import 'package:loudly/Models/grouppoll.dart';
import 'package:loudly/Models/groupuser.dart';
import 'package:loudly/project_textconstants.dart';
import 'package:loudly/resources/ws/message_models/general_message_format.dart';
import 'package:loudly/resources/ws/message_store.dart';
import 'package:loudly/resources/ws/websocket.dart';
import 'package:loudly/resources/ws/wsutility.dart';
import 'package:loudly/ui/globals.dart';

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
  static const String getMyGroupsInfoEvent = 'getMyGroupsInfo';

  static Future<int> create(String groupName, String description,
      {Function callback}) async {
    try {
      int messageid = await WSUtility.getNextMessageId();
      Message message = Message(
          module: WSUtility.groupModule,
          event: createEvent,
          messageid: messageid,
          data: {'name': groupName, 'desc': description});
      MessageStore().add(message);

      WebSocketHelper().sendMessage(message.toJson(), callback: callback);
      return messageid;
    } catch (Exception) {
      throw Exception(sendingWSMessageFailed);
    }
  }

  static Future<int> getInfo(List<int> groupids, {Function callback}) async {
    try {
      int messageid = await WSUtility.getNextMessageId();
      Message message = Message(
          module: WSUtility.groupModule,
          event: getInfoEvent,
          messageid: messageid,
          data: {'groupids': groupids});
      MessageStore().add(message);

      WebSocketHelper().sendMessage(message.toJson(), callback: callback);
      return messageid;
    } catch (Exception) {
      throw Exception(sendingWSMessageFailed);
    }
  }

  static Future<int> getUsersOfGroup(int groupid, {Function callback}) async {
    try {
      int messageid = await WSUtility.getNextMessageId();
      Message message = Message(
          module: WSUtility.groupModule,
          event: getUsersOfGroupEvent,
          messageid: messageid,
          data: {'groupid': groupid});
      MessageStore().add(message);

      WebSocketHelper().sendMessage(message.toJson(), callback: callback);
      return messageid;
    } catch (Exception) {
      throw Exception(sendingWSMessageFailed);
    }
  }

  static Future<int> getPolls(int groupid, {Function callback}) async {
    try {
      int messageid = await WSUtility.getNextMessageId();
      Message message = Message(
          module: WSUtility.groupModule,
          event: getPollsEvent,
          messageid: messageid,
          data: {'groupid': groupid});
      MessageStore().add(message);

      WebSocketHelper().sendMessage(message.toJson(), callback: callback);
      return messageid;
    } catch (Exception) {
      throw Exception(sendingWSMessageFailed);
    }
  }

  static Future<int> addUser(int groupid, int userid, String permission,
      {Function callback}) async {
    try {
      int messageid = await WSUtility.getNextMessageId();
      Message message = Message(
          module: WSUtility.groupModule,
          event: addUserEvent,
          messageid: messageid,
          data: {
            'groupid': groupid,
            'user_id': userid,
            'permission': permission
          });
      MessageStore().add(message);

      WebSocketHelper().sendMessage(message.toJson(), callback: callback);
      return messageid;
    } catch (Exception) {
      throw Exception(sendingWSMessageFailed);
    }
  }

  static Future<int> changeTitle(int groupid, String groupTitle,
      {Function callback}) async {
    try {
      int messageid = await WSUtility.getNextMessageId();
      Message message = Message(
          module: WSUtility.groupModule,
          event: changeTitleEvent,
          messageid: messageid,
          data: {'groupid': groupid, 'name': groupTitle});
      MessageStore().add(message);

      WebSocketHelper().sendMessage(message.toJson(), callback: callback);
      return messageid;
    } catch (Exception) {
      throw Exception(sendingWSMessageFailed);
    }
  }

  static Future<int> changeDesc(int groupid, String groupDesc,
      {Function callback}) async {
    try {
      int messageid = await WSUtility.getNextMessageId();
      Message message = Message(
          module: WSUtility.groupModule,
          event: changeDescEvent,
          messageid: messageid,
          data: {'groupid': groupid, 'desc': groupDesc});
      MessageStore().add(message);

      WebSocketHelper().sendMessage(message.toJson(), callback: callback);
      return messageid;
    } catch (Exception) {
      throw Exception(sendingWSMessageFailed);
    }
  }

  static Future<int> changeUserPermission(
      int groupid, int userid, String permission,
      {Function callback}) async {
    try {
      int messageid = await WSUtility.getNextMessageId();
      Message message = Message(
          module: WSUtility.groupModule,
          event: changeUserPermissionEvent,
          messageid: messageid,
          data: {
            'groupid': groupid,
            'user_id': userid,
            'permission': permission
          });
      MessageStore().add(message);

      WebSocketHelper().sendMessage(message.toJson(), callback: callback);
      return messageid;
    } catch (Exception) {
      throw Exception(sendingWSMessageFailed);
    }
  }

  static Future<int> removeUser(int groupid, int userid,
      {Function callback}) async {
    try {
      int messageid = await WSUtility.getNextMessageId();
      Message message = Message(
          module: WSUtility.groupModule,
          event: removeUserEvent,
          messageid: messageid,
          data: {'groupid': groupid, 'user_id': userid});
      MessageStore().add(message);

      WebSocketHelper().sendMessage(message.toJson(), callback: callback);
      return messageid;
    } catch (Exception) {
      throw Exception(sendingWSMessageFailed);
    }
  }

  static Future<int> getMyGroupsInfo({Function callback}) async {
    try {
      int messageid = await WSUtility.getNextMessageId();
      Message message = Message(
          module: WSUtility.groupModule,
          event: getMyGroupsInfoEvent,
          messageid: messageid);
      MessageStore().add(message);

      WebSocketHelper().sendMessage(message.toJson(), callback: callback);
      return messageid;
    } catch (Exception) {
      throw Exception(sendingWSMessageFailed);
    }
  }

//----------------------------------------------------------------------------------------------------------------------------
  static Future<void> onMessage(
      GeneralMessageFormat genFormatMessage, Message sentMessage) async {
    switch (genFormatMessage.message.event) {
      case createEvent:
        createReply(genFormatMessage, sentMessage: sentMessage);
        break;
      case getInfoEvent:
        getInfoReply(genFormatMessage);
        break;
      case getUsersOfGroupEvent:
        getUsersOfGroupReply(genFormatMessage);
        break;
      case getPollsEvent:
        getPollsReply(genFormatMessage);
        break;
      case addUserEvent:
        addUserReply(genFormatMessage, sentMessage: sentMessage);
        break;
      case changeTitleEvent:
        changeTitleReply(genFormatMessage, sentMessage: sentMessage);
        break;
      case changeDescEvent:
        changeDescReply(genFormatMessage, sentMessage: sentMessage);
        break;
      case changeUserPermissionEvent:
        changeUserPermissionReply(genFormatMessage, sentMessage: sentMessage);
        break;
      case removeUserEvent:
        removeUserReply(genFormatMessage, sentMessage: sentMessage);
        break;
      case getMyGroupsInfoEvent:
        getMyGroupsInfoReply(genFormatMessage);
        break;
    }
  }

  static Future<void> createReply(GeneralMessageFormat genFormatMessage,
      {@required Message sentMessage}) async {
    try {
      //Prepare data
      GroupInfoModel groupInfo = new GroupInfoModel(
          groupid: genFormatMessage.message.data['groupid'],
          name: sentMessage.data['name'],
          desc: sentMessage.data['desc'],
          createdBy: Globals.selfUserId,
          createdAt: genFormatMessage.message.data['createdAt']);

      await GroupInfoModel.insert(groupInfo);
    } catch (Exception) {
      throw Exception(parsingWSMessageFailed);
    }
  }

  static Future<void> getInfoReply(
      GeneralMessageFormat genFormatMessage) async {
    try {
      List<GroupInfoModel> groupInfoList =
          groupInfoFromList(genFormatMessage.message.data);
      for (GroupInfoModel groupInfo in groupInfoList) {
        GroupInfoModel.insert(groupInfo);
      }
    } catch (Exception) {
      throw Exception(parsingWSMessageFailed);
    }
  }

  static Future<void> getUsersOfGroupReply(
      GeneralMessageFormat genFormatMessage) async {
    try {
      List<GroupUserModel> groupUserList =
          groupUserFromList(genFormatMessage.message.data);
      for (GroupUserModel groupUser in groupUserList) {
        GroupUserModel.insert(groupUser);
      }
    } catch (Exception) {
      throw Exception(parsingWSMessageFailed);
    }
  }

  static Future<void> getPollsReply(
      GeneralMessageFormat genFormatMessage) async {
    try {
      List<GroupPollModel> groupPollList =
          groupPollFromList(genFormatMessage.message.data);
      for (GroupPollModel groupPoll in groupPollList) {
        GroupPollModel.insert(groupPoll);
      }
    } catch (Exception) {
      throw Exception(parsingWSMessageFailed);
    }
  }

  static Future<void> addUserReply(GeneralMessageFormat genFormatMessage,
      {@required Message sentMessage}) async {
    try {
      GroupUserModel data = new GroupUserModel(
          groupid: sentMessage.data['groupid'],
          userId: sentMessage.data['user_id'],
          permission: sentMessage.data['permission'],
          addedBy: Globals.selfUserId,
          createdAt: sentMessage.data['createdAt']);

      GroupUserModel.insert(data);
    } catch (Exception) {
      throw Exception(parsingWSMessageFailed);
    }
  }

  static Future<void> changeTitleReply(GeneralMessageFormat genFormatMessage,
      {@required Message sentMessage}) async {
    try {
      //Prepare data
      GroupInfoModel.updateTitle(
          sentMessage.data['groupid'], sentMessage.data['name']);
    } catch (Exception) {
      throw Exception(parsingWSMessageFailed);
    }
  }

  static Future<void> changeDescReply(GeneralMessageFormat genFormatMessage,
      {@required Message sentMessage}) async {
    try {
      //Prepare data
      GroupInfoModel.updateDesc(
          sentMessage.data['groupid'], sentMessage.data['desc']);
    } catch (Exception) {
      throw Exception(parsingWSMessageFailed);
    }
  }

  static Future<void> changeUserPermissionReply(
      GeneralMessageFormat genFormatMessage,
      {@required Message sentMessage}) async {
    try {
      GroupUserModel.updatePermission(sentMessage.data['groupid'],
          sentMessage.data['user_id'], sentMessage.data['permission']);
    } catch (Exception) {
      throw Exception(parsingWSMessageFailed);
    }
  }

  static Future<void> removeUserReply(GeneralMessageFormat genFormatMessage,
      {@required Message sentMessage}) async {
    try {
      GroupUserModel.delete(
          sentMessage.data['groupid'], sentMessage.data['user_id']);
    } catch (Exception) {
      throw Exception(parsingWSMessageFailed);
    }
  }

  static Future<void> getMyGroupsInfoReply(
      GeneralMessageFormat genFormatMessage) async {
    try {
      List<GroupInfoModel> groupInfoList =
          groupInfoFromList(genFormatMessage.message.data);
      for (GroupInfoModel groupInfo in groupInfoList) {
        await GroupInfoModel.insert(groupInfo);
      }
    } catch (Exception) {
      throw Exception(parsingWSMessageFailed);
    }
  }
}
