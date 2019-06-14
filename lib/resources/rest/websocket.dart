import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class WebSocketListener {
  WebSocketChannel channel;
  bool bConnectionEstablished = false;

  static final WebSocketListener _instance = WebSocketListener._internal();
  factory WebSocketListener() => _instance;

  WebSocketListener._internal() {
    // init things inside this
    try {
      final storage = new FlutterSecureStorage();
      storage.read(key: 'token').then((onValue) {
        var headers = {'token': onValue};

        this.channel = IOWebSocketChannel.connect(
            'wss://loudly.loudspeakerdev.net',
            headers: headers);

        bConnectionEstablished = true;
        channel.stream.listen((dynamic message) {
          print(message);
        });
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
