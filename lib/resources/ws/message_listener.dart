import 'package:loudly/resources/ws/event_handlers/groupmodule.dart';
import 'package:loudly/resources/ws/event_handlers/pollmodule.dart';
import 'package:loudly/resources/ws/message_models/general_message_format.dart';
import 'package:loudly/resources/ws/message_store.dart';
import 'package:loudly/resources/ws/wsutility.dart';
import 'package:loudly/resources/ws/event_handlers/usermodule.dart';

class MessageListener {
  static final MessageListener _instance = MessageListener._internal();
  factory MessageListener() => _instance;

  MessageListener._internal() {
    // init things inside this
  }

  void processInMessage(GeneralMessageFormat recvdMessage, {Function callback}) {
    Message sentMessage = MessageStore().remove(recvdMessage.message.messageid);
    try {
      switch (recvdMessage.message.module) {
        case WSUtility.userModule:
          WSUsersModule.onMessage(recvdMessage, sentMessage);
          break;
        case WSUtility.groupModule:
          WSGroupsModule.onMessage(recvdMessage, sentMessage);
          break;
          case WSUtility.pollModule:
          WSPollsModule.onMessage(recvdMessage, sentMessage);
          break;
      }
    } catch (Exception) {
      print(Exception);
    }
  }
}
