import 'package:synchronized/synchronized.dart';

class WSUtility {
  static const String userModule = 'users';
  static const String pollModule = 'polls';
  static const String groupModule = 'groups';

  static int messageid = 1000;
  static var lock = Lock();

  static Future<int> getNextMessageId() async {
    return await lock.synchronized(() {
      messageid++;
      return messageid;
    });
  }
}
