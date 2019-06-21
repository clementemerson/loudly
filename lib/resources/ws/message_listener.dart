import 'package:loudly/resources/ws/message_models/general_message_format.dart';
import 'package:loudly/resources/ws/websocket_messagemodules.dart';
import 'package:loudly/resources/ws/wsmessage_usermodulehelper.dart';

class MessageListener {

  static final MessageListener _instance = MessageListener._internal();
  factory MessageListener() => _instance;

  MessageListener._internal() {
    // init things inside this
  }

  void processMessageFromWebsocketConnection(dynamic message) {
    print(message);
    final GeneralMessageFormat genFormatMessage = generalMessageFormatFromJson(message.toString());
    switch(genFormatMessage.module) {
      case WebSocketMessageModules.userModule:
        WebSocketUsersModuleHelper.onReceivedMessage(genFormatMessage);
    }
  }
}
