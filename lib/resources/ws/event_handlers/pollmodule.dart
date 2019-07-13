import 'package:flutter/widgets.dart';
import 'package:loudly/models/grouppoll.dart';
import 'package:loudly/models/polldata.dart';
import 'package:loudly/resources/ws/message_models/general_message_format.dart';
import 'package:loudly/resources/ws/message_store.dart';
import 'package:loudly/resources/ws/websocket.dart';
import 'package:loudly/resources/ws/wsutility.dart';
import 'package:loudly/ui/globals.dart';

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
  static const String getMyPollsInfoEvent = 'getMyPollsInfo';

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
            'options': pollOptionListToJson(pollData.options)
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

  static Future<int> getMyPollsInfo({Function callback}) async {
    try {
      int messageid = await WSUtility.getNextMessageId();
      Message message = Message(
          module: WSUtility.pollModule,
          event: getMyPollsInfoEvent,
          messageid: messageid);
      MessageStore().add(message);

      WebSocketHelper().sendMessage(message.toJson(), callback: callback);
      return messageid;
    } catch (Exception) {
      throw Exception('Failed to send message to server via websocket');
    }
  }

//----------------------------------------------------------------------------------------------------------------------------
  static Future<void> onMessage(
      GeneralMessageFormat genFormatMessage, Message sentMessage) async {
    switch (genFormatMessage.message.event) {
      case createEvent:
        await createReply(genFormatMessage, sentMessage: sentMessage);
        break;
      case shareToGroupEvent:
        await shareToGroupReply(genFormatMessage, sentMessage: sentMessage);
        break;
      case getInfoEvent:
        await getInfoReply(genFormatMessage);
        break;
      case voteEvent:
        await voteReply(genFormatMessage);
        break;
      case getUsersVoteInfoEvent:
        await getUsersVoteInfoReply(genFormatMessage);
        break;
      case syncPollResultsEvent:
        await syncPollResultsReply(genFormatMessage);
        break;
      case subscribeToPollResultEvent:
        await subscribeToPollResultReply(genFormatMessage);
        break;
      case unSubscribeToPollResultEvent:
        await unSubscribeToPollResultReply(genFormatMessage);
        break;
      case deleteEvent:
        await deleteReply(genFormatMessage, sentMessage: sentMessage);
        break;
      case getMyPollsInfoEvent:
        await getMyPollsInfoReply(genFormatMessage);
        break;
    }
  }

  static Future<void> createReply(GeneralMessageFormat genFormatMessage,
      {@required Message sentMessage}) async {
    try {
      //Prepare data
      PollData data = new PollData(
          pollid: genFormatMessage.message.data['pollid'],
          title: sentMessage.data['title'],
          options: pollOptionFromList(sentMessage.data['options'], genFormatMessage.message.data['pollid']),
          canBeShared: sentMessage.data['canbeshared'],
          resultIsPublic: sentMessage.data['resultispublic'],
          createdBy: Globals.self_userid,
          createdAt: genFormatMessage.message.data['createdAt'],
          voted: false);

      PollData.insert(data);
    } catch (Exception) {
      throw Exception('Failed to parse message from server');
    }
  }

  static Future<void> shareToGroupReply(GeneralMessageFormat genFormatMessage,
      {@required Message sentMessage}) async {
    try {
      GroupPoll data = new GroupPoll(
          pollid: sentMessage.data['pollid'],
          groupid: sentMessage.data['groupid'],
          sharedBy: Globals.self_userid,
          createdAt: genFormatMessage.message.data.createdAt,
          archived: false);
      GroupPoll.insert(data);
    } catch (Exception) {
      throw Exception('Failed to parse message from server');
    }
  }

  static Future<void> getInfoReply(
      GeneralMessageFormat genFormatMessage) async {
    try {
      List<PollData> pollInfoList =
          pollInfoFromList(genFormatMessage.message.data);
      for (PollData pollInfo in pollInfoList) {
        await PollData.insert(pollInfo);
      }
    } catch (Exception) {
      throw Exception('Failed to parse message from server');
    }
  }

  static Future<void> voteReply(GeneralMessageFormat genFormatMessage) async {
    try {
      //Todo:
    } catch (Exception) {
      throw Exception('Failed to parse message from server');
    }
  }

  static Future<void> getUsersVoteInfoReply(
      GeneralMessageFormat genFormatMessage) async {
    try {
      //Todo:
    } catch (Exception) {
      throw Exception('Failed to parse message from server');
    }
  }

  static Future<void> syncPollResultsReply(
      GeneralMessageFormat genFormatMessage) async {
    try {
      //Todo:
    } catch (Exception) {
      throw Exception('Failed to parse message from server');
    }
  }

  static Future<void> subscribeToPollResultReply(
      GeneralMessageFormat genFormatMessage) async {
    try {
      //Todo:
    } catch (Exception) {
      throw Exception('Failed to parse message from server');
    }
  }

  static Future<void> unSubscribeToPollResultReply(
      GeneralMessageFormat genFormatMessage) async {
    try {
      //Todo:
    } catch (Exception) {
      throw Exception('Failed to parse message from server');
    }
  }

  static Future<void> deleteReply(GeneralMessageFormat genFormatMessage,
      {Message sentMessage}) async {
    try {
      PollData.delete(sentMessage.data['pollid']);
    } catch (Exception) {
      throw Exception('Failed to parse message from server');
    }
  }

  static Future<void> getMyPollsInfoReply(
      GeneralMessageFormat genFormatMessage) async {
    try {
      List<PollData> pollInfoList =
          pollInfoFromList(genFormatMessage.message.data);
      for (PollData pollInfo in pollInfoList) {
        await PollData.insert(pollInfo);
      }
    } catch (Exception) {
      throw Exception('Failed to parse message from server');
    }
  }
}
