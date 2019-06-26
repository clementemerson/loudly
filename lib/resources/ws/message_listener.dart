import 'package:loudly/resources/ws/message_models/general_message_format.dart';
import 'package:loudly/resources/ws/wsutility.dart';
import 'package:loudly/resources/ws/event_handlers/usermodule.dart';

class MessageListener {
  static final MessageListener _instance = MessageListener._internal();
  factory MessageListener() => _instance;

  MessageListener._internal() {
    // init things inside this
  }

  void processInMessage(GeneralMessageFormat message,
      {Function callback}) {
    try {
      switch (message.message.module) {
        case WSUtility.userModule:
          WSUsersModule.onMessage(message);
      }
    } catch (Exception) {
      print(Exception);
    }
  }
}
