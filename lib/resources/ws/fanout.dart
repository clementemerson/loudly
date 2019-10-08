import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:loudly/project_textconstants.dart';
import 'package:loudly/resources/ws/message_listener.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'message_models/general_message_format.dart';

class FanoutHelper {
  //static final String serverName = 'wss://loudly.loudspeakerdev.net:9080';
  static final String serverName = 'ws://127.0.0.1:9080';
  //static final String serverName = 'ws://10.0.2.2:9080';

  static final String wsConnectionDone = '';
  static final String wsConnectionClosed = 'ws close onDone';
  static final String wsConnectionError = 'ws close error';
  static final String sending = 'sending';
  static final String receiving = 'receiving';

  WebSocketChannel channel;
  bool _connEstablished = false;
  bool _connIsBeingEstablished = false;
  final callbackRegister = new Map();

  static final FanoutHelper _instance = FanoutHelper._internal();
  factory FanoutHelper() => _instance;
  bool firstMessageReceived = false;

  FanoutHelper._internal() {
    // init things inside this
    _connEstablished = false;
  }

  bool get connectionEstablished {
    return this._connEstablished;
  }

  Future initConnection({@required String token, Function initCallback}) async {
    try {
      if (_connEstablished == true || _connIsBeingEstablished == true) return;
      _connIsBeingEstablished = true;

      //var headers = {'token': token};
      String connectionString = FanoutHelper.serverName + '?token=$token';

      WebSocket ws = await WebSocket.connect(connectionString);
      ws.listen(
        (message) {
          handleIncomingMessage(message, initCallback: initCallback);
        },
        onDone: () {
          _connEstablished = false;
          _connIsBeingEstablished = false;
          initCallback(false);
          ws.close();
          print(wsConnectionClosed);
        },
        onError: (error) {
          _connEstablished = false;
          _connIsBeingEstablished = false;
          initCallback(false);
          ws.close();
          print('$wsConnectionError = $error');
        },
      );
      this.channel = IOWebSocketChannel(ws);

      _connEstablished = true;
      _connIsBeingEstablished = false;
    } catch (Exception) {
      print(Exception);
      _connEstablished = false;
      _connIsBeingEstablished = false;
      throw Exception(initWSConnectionFailed);
    }
  }

  void handleIncomingMessage(message, {Function initCallback}) async {
    try {
      print('$receiving: $message');
      if (firstMessageReceived == false) {
        firstMessageReceived = true;
        _connEstablished = true;
        initCallback(true);
      }

      dynamic messageContent = json.decode(message);

      if (messageContent[GeneralMessageFormat.jsonStatus] ==
          GeneralMessageFormat.jsonSuccess) {
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
