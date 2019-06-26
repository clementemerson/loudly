import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:loudly/resources/ws/message_listener.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'message_models/general_message_format.dart';

class WebSocketHelper {
  //static String serverName = 'wss://loudly.loudspeakerdev.net:8080';
  static String serverName = 'ws://127.0.0.1:8080';
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
      //token = 'null';
      var headers = {'token': token};
      String connectionString = WebSocketHelper.serverName + '?token=$token';

      WebSocket ws = await WebSocket.connect(connectionString);
      print('ws open');
      ws.listen(
        (message) {
          handleIncomingMessage(message, initCallback: initCallback);
        },
        onDone: () {
          bConnectionEstablished = false;
          initCallback(false);
          ws.close();
          print('ws close onDone');
        },
        onError: (error) {
          bConnectionEstablished = false;
          initCallback(false);
          ws.close();
          print('ws close error = $error');
        },
      );
      this.channel = IOWebSocketChannel(ws);

      //this.channel = IOWebSocketChannel.connect(connectionString);
      print(this.channel.toString());
      this.channel.sink.add('data');
    } catch (Exception) {
      print(Exception);
      bConnectionEstablished = false;
      throw Exception('Failed to instantiate websocket connection');
    }
  }

  void sendMessage(var message, {Function callback}) {
    try {
      if (bConnectionEstablished == true) {
        callbackRegister[message['messageid']] = callback;
        channel.sink.add(json.encode(message));
      } else {
        throw Exception('Websocket connection is not established yet');
      }
    } catch (Exception) {
      throw Exception('Failed to send message via websocket');
    }
  }

  void handleIncomingMessage(message, {Function initCallback}) {
    try {
      print(message);
      if (firstMessageReceived == false) {
        firstMessageReceived = true;
        bConnectionEstablished = true;
        initCallback(true);
      }

      dynamic messageContent = json.decode(message);

      if (messageContent['Status'] == 'Success') {
        final GeneralMessageFormat genFormatMessage =
            generalMessageFormatFromJson(message);

        final callbackFunction =
            callbackRegister[genFormatMessage.message.messageid];
        MessageListener()
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
