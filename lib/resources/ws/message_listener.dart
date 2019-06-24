import 'dart:convert';

import 'package:loudly/resources/ws/message_models/general_message_format.dart';
import 'package:loudly/resources/ws/websocket_messagemodules.dart';
import 'package:loudly/resources/ws/wsmessage_usermodulehelper.dart';

class MessageListener {
  static final MessageListener _instance = MessageListener._internal();
  factory MessageListener() => _instance;

  MessageListener._internal() {
    // init things inside this
  }

  void processMessageFromWebsocketConnection(String message, Function callback) {
    print(message);
    dynamic messageContent = json.decode(message);
    if (messageContent['Status'] == 'Success') {
      final GeneralMessageFormat genFormatMessage =
          generalMessageFormatFromJson(message);
      switch (genFormatMessage.details.module) {
        case WebSocketMessageModules.userModule:
          WebSocketUsersModuleHelper.onReceivedMessage(genFormatMessage);
      }
    }
  }
}
