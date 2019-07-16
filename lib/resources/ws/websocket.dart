import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:loudly/project_textconstants.dart';
import 'package:loudly/resources/ws/message_listener.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'message_models/general_message_format.dart';

class WebSocketHelper {
  //static final String serverName = 'wss://loudly.loudspeakerdev.net:8080';
  static final String serverName = 'ws://127.0.0.1:8080';

  static final String wsConnectionDone = '';
  static final String wsConnectionClosed = 'ws close onDone';
  static final String wsConnectionError = 'ws close error';
  static final String sending = 'sending';
  static final String receiving = 'receiving';

  WebSocketChannel channel;
  bool bConnectionEstablished = false;
  final callbackRegister = new Map();

  static final WebSocketHelper _instance = WebSocketHelper._internal();
  factory WebSocketHelper() => _instance;
  bool firstMessageReceived = false;

  WebSocketHelper._internal() {
    // init things inside this
    bConnectionEstablished = false;
  }

  bool isConnectionEstablished() {
    return this.bConnectionEstablished;
  }

  Future initConnection({@required String token, Function initCallback}) async {
    try {
      //var headers = {'token': token};
      String connectionString = WebSocketHelper.serverName + '?token=$token';

      WebSocket ws = await WebSocket.connect(connectionString);
      ws.listen(
        (message) {
          handleIncomingMessage(message, initCallback: initCallback);
        },
        onDone: () {
          bConnectionEstablished = false;
          initCallback(false);
          ws.close();
          print(wsConnectionClosed);
        },
        onError: (error) {
          bConnectionEstablished = false;
          initCallback(false);
          ws.close();
          print('$wsConnectionError = $error');
        },
      );
      this.channel = IOWebSocketChannel(ws);

      bConnectionEstablished = true;
    } catch (Exception) {
      print(Exception);
      bConnectionEstablished = false;
      throw Exception(initWSConnectionFailed);
    }
  }

  void sendMessage(var message, {Function callback}) {
    try {
      print('$sending: $message');
      if (bConnectionEstablished == true) {
        callbackRegister[message[Message.jsonMessageId]] = callback;
        channel.sink.add(json.encode(message));
      } else {
        throw Exception(noWSConnection);
      }
    } catch (Exception) {
      throw Exception(sendingWSMessageFailed);
    }
  }

  void handleIncomingMessage(message, {Function initCallback}) async {
    try {
      print('$receiving: $message');
      if (firstMessageReceived == false) {
        firstMessageReceived = true;
        bConnectionEstablished = true;
        initCallback(true);
      }

      dynamic messageContent = json.decode(message);

      if (messageContent[GeneralMessageFormat.jsonStatus] == GeneralMessageFormat.jsonSuccess) {
        final GeneralMessageFormat genFormatMessage =
            generalMessageFormatFromJson(message);

        final callbackFunction =
            callbackRegister[genFormatMessage.message.messageid];
        await MessageListener()
            .processInMessage(genFormatMessage, callback: callbackFunction);

        if (callbackFunction != null) {
          callbackFunction();
          callbackRegister.remove(genFormatMessage.message.messageid);
        }
      }
    } catch (Exception) {
      print(Exception);
    }
  }
}
