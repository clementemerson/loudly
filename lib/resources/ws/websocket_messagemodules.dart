import 'package:synchronized/synchronized.dart';

class WebSocketMessageModules {
  static const String userModule = 'users';

  static int messageid = 1000;
  static var lock = Lock();

  static Future<int> getNextMessageId() async {
    return await lock.synchronized(() {
      messageid++;
      return messageid;
    });
  }
}
