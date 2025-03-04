import 'package:flutter/widgets.dart';
import 'package:loudly/models/group_poll_model.dart';
import 'package:loudly/models/poll_data_model.dart';
import 'package:loudly/models/user_vote_model.dart';
import 'package:loudly/project_textconstants.dart';
import 'package:loudly/resources/ws/message_models/general_message_format.dart';
import 'package:loudly/resources/ws/message_store.dart';
import 'package:loudly/resources/ws/websocket.dart';
import 'package:loudly/resources/ws/wsutility.dart';
import 'package:loudly/ui/globals.dart';
import 'package:loudly/ui/widgets/toast_generator.dart';

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
  static const String getMyVotesEvent = 'getMyVotes';

  static Future<int> create(PollDataModel pollData, {Function callback}) async {
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

      ToastGenerator.showCenterToast(creatingPoll);
      WebSocketHelper().sendMessage(message.toJson(), callback: callback);
      return messageid;
    } catch (Exception) {
      throw Exception(sendingWSMessageFailed);
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
      throw Exception(sendingWSMessageFailed);
    }
  }

  static Future<int> shareToGroup(int pollid, List<int> groupids,
      {Function callback}) async {
    try {
      int messageid = await WSUtility.getNextMessageId();
      Message message = Message(
          module: WSUtility.pollModule,
          event: shareToGroupEvent,
          messageid: messageid,
          data: {'pollid': pollid, 'groupids': groupids});
      MessageStore().add(message);

      WebSocketHelper().sendMessage(message.toJson(), callback: callback);
      return messageid;
    } catch (Exception) {
      throw Exception(sendingWSMessageFailed);
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
      throw Exception(sendingWSMessageFailed);
    }
  }

  static Future<int> getUsersVoteInfo(List<int> userIds, int pollid,
      {Function callback}) async {
    try {
      int messageid = await WSUtility.getNextMessageId();
      Message message = Message(
          module: WSUtility.pollModule,
          event: getUsersVoteInfoEvent,
          messageid: messageid,
          data: {'user_ids': userIds, 'pollid': pollid});
      MessageStore().add(message);

      WebSocketHelper().sendMessage(message.toJson(), callback: callback);
      return messageid;
    } catch (Exception) {
      throw Exception(sendingWSMessageFailed);
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
      throw Exception(sendingWSMessageFailed);
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
      throw Exception(sendingWSMessageFailed);
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
      throw Exception(sendingWSMessageFailed);
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
      throw Exception(sendingWSMessageFailed);
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
      throw Exception(sendingWSMessageFailed);
    }
  }

  static Future<int> getMyVotesInfo({Function callback}) async {
    try {
      int messageid = await WSUtility.getNextMessageId();
      Message message = Message(
          module: WSUtility.pollModule,
          event: getMyVotesEvent,
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
        await createReply(genFormatMessage, sentMessage: sentMessage);
        break;
      case shareToGroupEvent:
        await shareToGroupReply(genFormatMessage, sentMessage: sentMessage);
        break;
      case getInfoEvent:
        await getInfoReply(genFormatMessage);
        break;
      case voteEvent:
        await voteReply(genFormatMessage, sentMessage: sentMessage);
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
      case getMyVotesEvent:
        await getMyVotesInfoReply(genFormatMessage);
        break;
    }
  }

  static Future<void> createReply(GeneralMessageFormat genFormatMessage,
      {@required Message sentMessage}) async {
    try {
      //Prepare data
      PollDataModel data = new PollDataModel(
          pollid: genFormatMessage.message.data['pollid'],
          title: sentMessage.data['title'],
          options: pollOptionFromList(sentMessage.data['options'],
              genFormatMessage.message.data['pollid']),
          canBeShared: sentMessage.data['canbeshared'],
          resultIsPublic: sentMessage.data['resultispublic'],
          createdBy: Globals.selfUserId,
          createdAt: genFormatMessage.message.data['createdAt'],
          voted: false);

      PollDataModel.insert(data);
      ToastGenerator.cancelToast();
    } catch (Exception) {
      throw Exception(parsingWSMessageFailed);
    }
  }

  static Future<void> shareToGroupReply(GeneralMessageFormat genFormatMessage,
      {@required Message sentMessage}) async {
    try {
      final groupids = genFormatMessage.message.data['sharedToOK'];
      final pollid = sentMessage.data['pollid'];

      for (var groupid in groupids) {
        GroupPollModel data = new GroupPollModel(
            pollid: pollid,
            groupid: groupid,
            sharedBy: Globals.selfUserId,
            createdAt: genFormatMessage.message.data['createdAt'],
            archived: false);
        GroupPollModel.insert(data);
      }
      ToastGenerator.showBottomToast('Poll is shared...');
    } catch (Exception) {
      throw Exception(parsingWSMessageFailed);
    }
  }

  static Future<void> getInfoReply(
      GeneralMessageFormat genFormatMessage) async {
    try {
      List<PollDataModel> pollInfoList =
          pollInfoFromList(genFormatMessage.message.data);
      for (PollDataModel pollInfo in pollInfoList) {
        await PollDataModel.insert(pollInfo);
      }
    } catch (Exception) {
      throw Exception(parsingWSMessageFailed);
    }
  }

  static Future<void> voteReply(GeneralMessageFormat genFormatMessage,
      {@required Message sentMessage}) async {
    try {
      PollDataModel.markAsVoted(sentMessage.data['pollid']);
      ToastGenerator.showBottomToast('Voted successfully');
    } catch (Exception) {
      throw Exception(parsingWSMessageFailed);
    }
  }

  static Future<void> getUsersVoteInfoReply(
      GeneralMessageFormat genFormatMessage) async {
    try {
      //Todo:
    } catch (Exception) {
      throw Exception(parsingWSMessageFailed);
    }
  }

  static Future<void> syncPollResultsReply(
      GeneralMessageFormat genFormatMessage) async {
    try {
      //Todo:
    } catch (Exception) {
      throw Exception(parsingWSMessageFailed);
    }
  }

  static Future<void> subscribeToPollResultReply(
      GeneralMessageFormat genFormatMessage) async {
    try {
      //Todo:
    } catch (Exception) {
      throw Exception(parsingWSMessageFailed);
    }
  }

  static Future<void> unSubscribeToPollResultReply(
      GeneralMessageFormat genFormatMessage) async {
    try {
      //Todo:
    } catch (Exception) {
      throw Exception(parsingWSMessageFailed);
    }
  }

  static Future<void> deleteReply(GeneralMessageFormat genFormatMessage,
      {Message sentMessage}) async {
    try {
      PollDataModel.delete(sentMessage.data['pollid']);
    } catch (Exception) {
      throw Exception(parsingWSMessageFailed);
    }
  }

  static Future<void> getMyPollsInfoReply(
      GeneralMessageFormat genFormatMessage) async {
    try {
      List<PollDataModel> pollInfoList =
          pollInfoFromList(genFormatMessage.message.data);
      for (PollDataModel pollInfo in pollInfoList) {
        await PollDataModel.insert(pollInfo);
      }
    } catch (Exception) {
      throw Exception(parsingWSMessageFailed);
    }
  }

  static Future<void> getMyVotesInfoReply(
      GeneralMessageFormat genFormatMessage) async {
    try {
      List<UserVoteModel> userVoteList =
          userVoteFromList(genFormatMessage.message.data);
      for (UserVoteModel userVote in userVoteList) {
        await UserVoteModel.insert(userVote);
        await PollDataModel.markAsVoted(userVote.pollid);
      }
    } catch (Exception) {
      throw Exception(parsingWSMessageFailed);
    }
  }
}
