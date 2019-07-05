import 'package:loudly/Models/polldata.dart';
import 'package:loudly/resources/ws/message_models/general_message_format.dart';
import 'package:loudly/resources/ws/message_store.dart';
import 'package:loudly/resources/ws/websocket.dart';
import 'package:loudly/resources/ws/wsutility.dart';

class WSPollsModule {
//Event List
  static const String createEvent = 'create';
  static const String shareToGroupEvent = 'shareToGroup';
  static const String getInfoEvent = 'getInfo';
  static const String voteEvent = 'vote';
  static const String getUsersVoteInfoEvent = 'getUsersVoteInfo';
  static const String syncPollResultsEvent = 'syncPollResults';
  static const String subscribeToPollResultEvent = 'subscribeToPollResult';
  static const String unSubscribeToPollResultEvent = 'unSubscribeToPollResult';
  static const String deleteEvent = 'delete';

  static Future<int> create(PollData pollData, {Function callback}) async {
    try {
      int messageid = await WSUtility.getNextMessageId();
      Message message = Message(
          module: WSUtility.pollModule,
          event: createEvent,
          messageid: messageid,
          data: {
            'title': pollData.title,
            'canbeshared': pollData.canBeShared,
            'resultispublic': pollData.resultIsPublic,
            'options': pollData.options
          });
      MessageStore().add(message);

      WebSocketHelper().sendMessage(message.toJson(), callback: callback);
      return messageid;
    } catch (Exception) {
      throw Exception('Failed to send message to server via websocket');
    }
  }

  static Future<int> getInfo(List<int> pollids, {Function callback}) async {
    try {
      int messageid = await WSUtility.getNextMessageId();
      Message message = Message(
          module: WSUtility.pollModule,
          event: getInfoEvent,
          messageid: messageid,
          data: {'pollids': pollids});
      MessageStore().add(message);

      WebSocketHelper().sendMessage(message.toJson(), callback: callback);
      return messageid;
    } catch (Exception) {
      throw Exception('Failed to send message to server via websocket');
    }
  }

  static Future<int> shareToGroup(int pollid, int groupid,
      {Function callback}) async {
    try {
      int messageid = await WSUtility.getNextMessageId();
      Message message = Message(
          module: WSUtility.pollModule,
          event: shareToGroupEvent,
          messageid: messageid,
          data: {'pollid': pollid, 'groupid': groupid});
      MessageStore().add(message);

      WebSocketHelper().sendMessage(message.toJson(), callback: callback);
      return messageid;
    } catch (Exception) {
      throw Exception('Failed to send message to server via websocket');
    }
  }

  static Future<int> vote(int pollid, int optionindex, bool isSecretVote,
      {Function callback}) async {
    try {
      int messageid = await WSUtility.getNextMessageId();
      Message message = Message(
          module: WSUtility.pollModule,
          event: voteEvent,
          messageid: messageid,
          data: {
            'pollid': pollid,
            'optionindex': optionindex,
            'secretvote': isSecretVote
          });
      MessageStore().add(message);

      WebSocketHelper().sendMessage(message.toJson(), callback: callback);
      return messageid;
    } catch (Exception) {
      throw Exception('Failed to send message to server via websocket');
    }
  }

  static Future<int> getUsersVoteInfo(List<int> user_ids, int pollid,
      {Function callback}) async {
    try {
      int messageid = await WSUtility.getNextMessageId();
      Message message = Message(
          module: WSUtility.pollModule,
          event: getUsersVoteInfoEvent,
          messageid: messageid,
          data: {'user_ids': user_ids, 'pollid': pollid});
      MessageStore().add(message);

      WebSocketHelper().sendMessage(message.toJson(), callback: callback);
      return messageid;
    } catch (Exception) {
      throw Exception('Failed to send message to server via websocket');
    }
  }

  static Future<int> syncPollResults(int lastsynchedtime,
      {Function callback}) async {
    try {
      int messageid = await WSUtility.getNextMessageId();
      Message message = Message(
          module: WSUtility.pollModule,
          event: syncPollResultsEvent,
          messageid: messageid,
          data: {'lastsynchedtime': lastsynchedtime});
      MessageStore().add(message);

      WebSocketHelper().sendMessage(message.toJson(), callback: callback);
      return messageid;
    } catch (Exception) {
      throw Exception('Failed to send message to server via websocket');
    }
  }

  static Future<int> subscribeToPollResult(int pollid,
      {Function callback}) async {
    try {
      int messageid = await WSUtility.getNextMessageId();
      Message message = Message(
          module: WSUtility.pollModule,
          event: subscribeToPollResultEvent,
          messageid: messageid,
          data: {'pollid': pollid});
      MessageStore().add(message);

      WebSocketHelper().sendMessage(message.toJson(), callback: callback);
      return messageid;
    } catch (Exception) {
      throw Exception('Failed to send message to server via websocket');
    }
  }

  static Future<int> unSubscribeToPollResult(int pollid,
      {Function callback}) async {
    try {
      int messageid = await WSUtility.getNextMessageId();
      Message message = Message(
          module: WSUtility.pollModule,
          event: unSubscribeToPollResultEvent,
          messageid: messageid,
          data: {'pollid': pollid});
      MessageStore().add(message);

      WebSocketHelper().sendMessage(message.toJson(), callback: callback);
      return messageid;
    } catch (Exception) {
      throw Exception('Failed to send message to server via websocket');
    }
  }

  static Future<int> delete(int pollid, {Function callback}) async {
    try {
      int messageid = await WSUtility.getNextMessageId();
      Message message = Message(
          module: WSUtility.pollModule,
          event: deleteEvent,
          messageid: messageid,
          data: {'pollid': pollid});
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
      case shareToGroupEvent:
        onShareToGroupReply(genFormatMessage);
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

  static void onShareToGroupReply(GeneralMessageFormat genFormatMessage) {
    try {
      print(genFormatMessage);
    } catch (Exception) {
      throw Exception('Failed to parse message from server');
    }
  }
}
