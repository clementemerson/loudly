import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:loudly/resources/ws/message_listener.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketHelper {
  //static String serverName = 'wss://loudly.loudspeakerdev.net:8080';
  static String serverName = 'ws://127.0.0.1:8080';
  WebSocketChannel channel;
  bool bConnectionEstablished = false;

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

  Future initConnection({@required String token, Function callback}) async {
    try {
      //token = 'null';
      var headers = {'token': token};
      String connectionString = WebSocketHelper.serverName + '?token=$token';

      WebSocket ws = await WebSocket.connect(connectionString);
      print('ws open');
      ws.listen(
        (message) {
          if (firstMessageReceived == false) {
            firstMessageReceived = true;
            bConnectionEstablished = true;
            callback(true);
          }
          MessageListener()
              .processMessageFromWebsocketConnection(message, callback);
        },
        onDone: () {
          bConnectionEstablished = false;
          callback(false);
          ws.close();
          print('ws close onDone');
        },
        onError: (error) {
          bConnectionEstablished = false;
          callback(false);
          ws.close();
          print('ws close error = $error');
        },
      );
      this.channel = IOWebSocketChannel(ws);

      this.channel = IOWebSocketChannel.connect(connectionString);
      print(this.channel.toString());
      this.channel.sink.add('data');

    } catch (Exception) {
      print(Exception);
      bConnectionEstablished = false;
      throw Exception('Failed to instantiate websocket connection');
    }
  }

  void sendMessage(String message) {
    try {
      if (bConnectionEstablished == true) {
        channel.sink.add(message);
      } else {
        throw Exception('Websocket connection is not established yet');
      }
    } catch (Exception) {
      throw Exception('Failed to send message via websocket');
    }
  }
}
