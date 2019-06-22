import 'package:flutter/widgets.dart';
import 'package:loudly/resources/ws/message_listener.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketHelper {
  //static String serverName = 'wss://loudly.loudspeakerdev.net:8080';
  static String serverName = 'ws://10.0.2.2:8080';
  WebSocketChannel channel;
  bool bConnectionEstablished = false;

  static final WebSocketHelper _instance = WebSocketHelper._internal();
  factory WebSocketHelper() => _instance;

  WebSocketHelper._internal() {
    // init things inside this
    bConnectionEstablished = false;
  }

  bool isConnectionEstablished() {
    return this.bConnectionEstablished;
  }

  void initConnection({@required String token}) {
    try {
      var headers = {'token': token};
      String connectionString = WebSocketHelper.serverName + '?token=$token';

      this.channel = IOWebSocketChannel.connect(connectionString);

      bConnectionEstablished = true;
      channel.stream.listen((dynamic message) {
        MessageListener().processMessageFromWebsocketConnection(message);
      });
    } catch (Exception) {
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
