import 'package:loudly/Models/groupinfo.dart';
import 'package:loudly/resources/ws/message_models/general_message_format.dart';
import 'package:loudly/resources/ws/message_store.dart';
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
      Message message = Message(
          module: WSUtility.groupModule,
          event: createEvent,
          messageid: messageid,
          data: {'name': groupInfo.name, 'desc': groupInfo.desc});
      MessageStore().add(message);

      WebSocketHelper().sendMessage(message.toJson(), callback: callback);
      return messageid;
    } catch (Exception) {
      throw Exception('Failed to send message to server via websocket');
    }
  }

  static Future<int> getInfo(List<int> groupids, {Function callback}) async {
    try {
      int messageid = await WSUtility.getNextMessageId();
      Message message = Message(
          module: WSUtility.groupModule,
          event: createEvent,
          messageid: messageid,
          data: {'groupids': groupids});
      MessageStore().add(message);

      WebSocketHelper().sendMessage(message.toJson(), callback: callback);
      return messageid;
    } catch (Exception) {
      throw Exception('Failed to send message to server via websocket');
    }
  }

  static Future<int> getUsersOfGroup(int groupid, {Function callback}) async {
    try {
      int messageid = await WSUtility.getNextMessageId();
      Message message = Message(
          module: WSUtility.groupModule,
          event: createEvent,
          messageid: messageid,
          data: {'groupid': groupid});
      MessageStore().add(message);

      WebSocketHelper().sendMessage(message.toJson(), callback: callback);
      return messageid;
    } catch (Exception) {
      throw Exception('Failed to send message to server via websocket');
    }
  }

  static Future<int> getPolls(int groupid, {Function callback}) async {
    try {
      int messageid = await WSUtility.getNextMessageId();
      Message message = Message(
          module: WSUtility.groupModule,
          event: createEvent,
          messageid: messageid,
          data: {'groupid': groupid});
      MessageStore().add(message);

      WebSocketHelper().sendMessage(message.toJson(), callback: callback);
      return messageid;
    } catch (Exception) {
      throw Exception('Failed to send message to server via websocket');
    }
  }

  static Future<int> addUser(int groupid, int userid, String permission,
      {Function callback}) async {
    try {
      int messageid = await WSUtility.getNextMessageId();
      Message message = Message(
          module: WSUtility.groupModule,
          event: createEvent,
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
      throw Exception('Failed to send message to server via websocket');
    }
  }

  static Future<int> changeTitle(int groupid, String groupTitle,
      {Function callback}) async {
    try {
      int messageid = await WSUtility.getNextMessageId();
      Message message = Message(
          module: WSUtility.groupModule,
          event: createEvent,
          messageid: messageid,
          data: {'groupid': groupid, 'name': groupTitle});
      MessageStore().add(message);

      WebSocketHelper().sendMessage(message.toJson(), callback: callback);
      return messageid;
    } catch (Exception) {
      throw Exception('Failed to send message to server via websocket');
    }
  }

  static Future<int> changeDesc(int groupid, String groupDesc,
      {Function callback}) async {
    try {
      int messageid = await WSUtility.getNextMessageId();
      Message message = Message(
          module: WSUtility.groupModule,
          event: createEvent,
          messageid: messageid,
          data: {'groupid': groupid, 'desc': groupDesc});
      MessageStore().add(message);

      WebSocketHelper().sendMessage(message.toJson(), callback: callback);
      return messageid;
    } catch (Exception) {
      throw Exception('Failed to send message to server via websocket');
    }
  }

  static Future<int> changeUserPermission(
      int groupid, int userid, String permission,
      {Function callback}) async {
    try {
      int messageid = await WSUtility.getNextMessageId();
      Message message = Message(
          module: WSUtility.groupModule,
          event: createEvent,
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
      throw Exception('Failed to send message to server via websocket');
    }
  }

  static Future<int> removeUser(int groupid, int userid,
      {Function callback}) async {
    try {
      int messageid = await WSUtility.getNextMessageId();
      Message message = Message(
          module: WSUtility.groupModule,
          event: createEvent,
          messageid: messageid,
          data: {'groupid': groupid, 'user_id': userid});
      MessageStore().add(message);

      WebSocketHelper().sendMessage(message.toJson(), callback: callback);
      return messageid;
    } catch (Exception) {
      throw Exception('Failed to send message to server via websocket');
    }
  }

//----------------------------------------------------------------------------------------------------------------------------
  static void onMessage(
      GeneralMessageFormat genFormatMessage, Message sentMessage) {
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
